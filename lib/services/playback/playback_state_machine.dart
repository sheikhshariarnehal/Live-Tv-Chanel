import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../models/channel.dart';
import 'auto_skip_manager.dart';
import 'buffer_monitor.dart';
import 'circuit_breaker.dart';
import 'connectivity_service.dart';
import 'error_classifier.dart';
import 'playback_state.dart';
import 'playback_telemetry.dart';
import 'retry_manager.dart';

/// Central orchestrator for the playback failure handling system.
///
/// Coordinates all sub-services (connectivity, error classification, retries,
/// buffer monitoring, circuit breaker, auto-skip) and produces an immutable
/// [PlaybackState] that the player widget observes for rendering.
///
/// All state transitions are explicit and logged. No boolean flag spaghetti.
///
/// ## Transition Rules
///
/// | From              | Event                         | To                  |
/// |-------------------|-------------------------------|---------------------|
/// | idle              | playChannel()                 | preparing           |
/// | preparing         | native state → buffering      | buffering           |
/// | preparing         | error + no internet           | waitingForInternet  |
/// | connecting        | native state → buffering      | buffering           |
/// | buffering         | native state → playing        | playing             |
/// | buffering         | stall detected                | retrying            |
/// | playing           | native state → buffering      | buffering           |
/// | playing           | user switches channel         | preparing           |
/// | *                 | error + no internet           | waitingForInternet  |
/// | *                 | error + retries remaining     | retrying            |
/// | retrying          | retry succeeds                | preparing           |
/// | retrying          | max retries exceeded          | skipping / failed   |
/// | waitingForInternet| internet restored             | preparing           |
/// | skipping          | countdown finished            | preparing (next ch) |
/// | skipping          | user cancels                  | failed              |
/// | failed            | user taps retry               | preparing           |
class PlaybackStateMachine extends ChangeNotifier {
  PlaybackStateMachine({
    required ConnectivityService connectivityService,
    ErrorClassifier? errorClassifier,
    RetryManager? retryManager,
    BufferMonitor? bufferMonitor,
    CircuitBreaker? circuitBreaker,
    AutoSkipManager? autoSkipManager,
    PlaybackTelemetry? telemetry,
  })  : _connectivity = connectivityService,
        _classifier = errorClassifier ?? const ErrorClassifier(),
        _retryManager = retryManager ?? RetryManager(),
        _bufferMonitor = bufferMonitor ?? BufferMonitor(),
        _circuitBreaker = circuitBreaker ?? CircuitBreaker(),
        _autoSkipManager = autoSkipManager ?? AutoSkipManager(),
        _telemetry = telemetry {
    // Listen for internet state changes
    _internetSub = _connectivity.stream.listen(_onInternetStateChanged);

    // Listen for buffer stalls
    _stallSub = _bufferMonitor.onStalled.listen(_onBufferStalled);
  }

  // ─── Dependencies ────────────────────────────────────────────────

  final ConnectivityService _connectivity;
  final ErrorClassifier _classifier;
  final RetryManager _retryManager;
  final BufferMonitor _bufferMonitor;
  final CircuitBreaker _circuitBreaker;
  final AutoSkipManager _autoSkipManager;
  final PlaybackTelemetry? _telemetry;

  StreamSubscription<InternetState>? _internetSub;
  StreamSubscription<Duration>? _stallSub;

  // ─── State ───────────────────────────────────────────────────────

  PlaybackState _state = const PlaybackState();
  PlaybackState get state => _state;

  /// The channel currently being played or attempted.
  Channel? _currentChannel;
  Channel? get currentChannel => _currentChannel;

  /// Related channels list for auto-skip navigation.
  List<Channel> _relatedChannels = [];

  /// Callbacks for the player widget.
  VoidCallback? onRetryPlayback;
  void Function(String channelId)? onSwitchChannel;
  VoidCallback? onSkipRequest;

  /// Timestamp when channel playback started — for startup time measurement.
  DateTime? _playbackStartTime;

  // ─── Public API ──────────────────────────────────────────────────

  /// Begin playback of a channel. Resets all recovery state.
  void playChannel(Channel channel, {List<Channel> relatedChannels = const []}) {
    debugPrint('StateMachine: playChannel(${channel.name})');

    // Cancel any in-flight recovery
    _retryManager.reset();
    _autoSkipManager.cancel();
    _bufferMonitor.reset();

    _currentChannel = channel;
    _relatedChannels = relatedChannels;
    _playbackStartTime = DateTime.now();

    _transition(PlaybackPhase.preparing, clearError: true);
  }

  /// Handle a raw event from the native ExoPlayer layer.
  ///
  /// Called by the player widget's `_handleMethodCall` for 'onStateChanged'.
  void handleNativeStateEvent(Map<String, dynamic> args) {
    final stateStr = args['state'] as String? ?? '';
    final isPlaying = args['isPlaying'] as bool? ?? false;

    // Update buffer monitor with each state event
    final bufferedMs = args['bufferedPosition'] as int?;
    final positionMs = args['position'] as int?;
    if (bufferedMs != null && positionMs != null) {
      _bufferMonitor.update(BufferSnapshot(
        bufferedPosition: Duration(milliseconds: bufferedMs),
        position: Duration(milliseconds: positionMs),
        timestamp: DateTime.now(),
      ));
    }

    switch (stateStr) {
      case 'buffering':
        if (_state.phase != PlaybackPhase.buffering &&
            _state.phase != PlaybackPhase.retrying) {
          _transition(PlaybackPhase.buffering);
          _bufferMonitor.startMonitoring();
        }
        // Update buffer state
        if (bufferedMs != null) {
          _state = _state.copyWith(
            isBufferGrowing: _bufferMonitor.isProgressing,
          );
        }
        break;

      case 'ready':
      case 'playing':
        if (isPlaying) {
          _onPlaybackStarted();
        }
        break;

      case 'idle':
      case 'ended':
        // Player stopped or stream ended — don't take action, handled elsewhere
        break;
    }
  }

  /// Handle a raw error from the native ExoPlayer layer.
  ///
  /// Called by the player widget's `_handleMethodCall` for 'onError'.
  void handleError(Map<String, dynamic> rawError) {
    debugPrint('StateMachine: handleError — ${rawError['message']}');

    // Classify the error
    final classified = _classifier.classify(
      rawError: rawError,
      internetState: _connectivity.state,
      isBufferGrowing: _bufferMonitor.isProgressing,
    );

    debugPrint('StateMachine: classified as ${classified.type} → ${classified.strategy}');

    // Record telemetry
    _telemetry?.recordError(
      channelId: _currentChannel?.id ?? '',
      channelName: _currentChannel?.name ?? '',
      errorType: classified.type,
      rawMessage: classified.rawMessage,
    );

    // Apply recovery strategy
    _applyRecoveryStrategy(classified);
  }

  /// Manual retry triggered by user tapping the Retry button.
  void manualRetry() {
    debugPrint('StateMachine: manual retry');
    _retryManager.reset();
    _autoSkipManager.cancel();
    _bufferMonitor.reset();
    _transition(PlaybackPhase.preparing, clearError: true);
    onRetryPlayback?.call();
  }

  /// User cancels auto-skip.
  void cancelSkip() {
    debugPrint('StateMachine: user cancelled skip');
    _autoSkipManager.cancel();
    _transition(PlaybackPhase.failed);
  }

  /// User requests immediate skip.
  void skipNow() {
    _autoSkipManager.skipNow();
  }

  /// Force the state machine into the failed state.
  void forceFail(ClassifiedError error) {
    _transition(PlaybackPhase.failed, error: error);
  }

  /// Update the related channels list (e.g., when category data loads).
  void updateRelatedChannels(List<Channel> channels) {
    _relatedChannels = channels;
  }

  // ─── Recovery Strategy Application ───────────────────────────────

  void _applyRecoveryStrategy(ClassifiedError error) {
    switch (error.strategy) {
      case RecoveryStrategy.waitForInternet:
        _retryManager.cancel();
        _autoSkipManager.cancel();
        _bufferMonitor.stopMonitoring();
        _transition(PlaybackPhase.waitingForInternet, error: error);
        break;

      case RecoveryStrategy.keepBuffering:
        // Don't take any action — just let it buffer
        debugPrint('StateMachine: keeping buffer alive (slow network)');
        break;

      case RecoveryStrategy.retryWithBackoff:
        _attemptRetry(error);
        break;

      case RecoveryStrategy.refreshAuth:
        // For now, treat as retry once (future: add token refresh logic)
        _attemptRetry(error);
        break;

      case RecoveryStrategy.refreshDrm:
        // DRM retry is handled natively (fallback stages in NativePlayerView.kt).
        // If we reach here, native fallbacks have been exhausted.
        _attemptRetry(error);
        break;

      case RecoveryStrategy.skip:
        _initiateSkip(error);
        break;

      case RecoveryStrategy.showError:
        _transition(PlaybackPhase.failed, error: error);
        break;
    }
  }

  void _attemptRetry(ClassifiedError error) {
    final config = _classifier.getRetryConfig(error.type);
    final nextAttempt = _state.retryAttempt + 1;

    // Check global outage first
    if (_circuitBreaker.isGlobalOutage) {
      debugPrint('StateMachine: global outage detected — not retrying');
      final isOffline = _connectivity.isOffline;
      _transition(
        PlaybackPhase.failed,
        error: ClassifiedError(
          type: isOffline ? ErrorType.noInternet : ErrorType.serverError,
          strategy: RecoveryStrategy.showError,
          rawMessage: isOffline
              ? 'No internet connection. Please check your network.'
              : 'Multiple channels failing. The provider server may be offline.',
          isRecoverable: true,
        ),
      );
      return;
    }

    final scheduled = _retryManager.scheduleRetry(
      config: config,
      attempt: nextAttempt,
      onRetry: () {
        if (_state.phase == PlaybackPhase.retrying) {
          debugPrint('StateMachine: executing retry $nextAttempt');
          _transition(PlaybackPhase.preparing, clearError: true);
          onRetryPlayback?.call();
        }
      },
    );

    if (scheduled) {
      _state = _state.copyWith(
        phase: PlaybackPhase.retrying,
        error: error,
        retryAttempt: nextAttempt,
        maxRetries: config.maxAttempts,
      );
      notifyListeners();
      debugPrint('StateMachine: → retrying ($nextAttempt/${config.maxAttempts})');

      _telemetry?.recordRetry(
        channelId: _currentChannel?.id ?? '',
        channelName: _currentChannel?.name ?? '',
        attempt: nextAttempt,
        maxAttempts: config.maxAttempts,
      );
    } else {
      // Max retries exceeded — record failure and initiate skip
      debugPrint('StateMachine: max retries exceeded');
      _circuitBreaker.recordFailure(_currentChannel?.id ?? '');
      _initiateSkip(error);
    }
  }

  void _initiateSkip(ClassifiedError error) {
    // Check if there's a valid next channel
    final nextChannelId = _autoSkipManager.selectNextChannel(
      currentChannelId: _currentChannel?.id ?? '',
      relatedChannels: _relatedChannels,
      circuitBreaker: _circuitBreaker,
    );

    if (nextChannelId == null) {
      if (onSkipRequest != null) {
        debugPrint('StateMachine: triggering onSkipRequest callback (immediate skip)');
        _retryManager.reset();
        _bufferMonitor.reset();
        onSkipRequest?.call();
        return;
      }
      // No valid channels — show error
      debugPrint('StateMachine: no valid channels to skip to');
      _transition(PlaybackPhase.failed, error: error);
      return;
    }

    debugPrint('StateMachine: initiating immediate skip → $nextChannelId');
    _retryManager.reset();
    _bufferMonitor.reset();

    _telemetry?.recordSkip(
      channelId: _currentChannel?.id ?? '',
      channelName: _currentChannel?.name ?? '',
      skipToChannelId: nextChannelId,
    );

    onSwitchChannel?.call(nextChannelId);
  }

  // ─── Event Handlers ──────────────────────────────────────────────

  void _onPlaybackStarted() {
    if (_state.phase == PlaybackPhase.playing) return;

    debugPrint('StateMachine: playback started');

    _bufferMonitor.stopMonitoring();
    _retryManager.cancel();
    _autoSkipManager.cancel();

    // Record success
    _circuitBreaker.recordSuccess(_currentChannel?.id ?? '');

    // Record startup time
    if (_playbackStartTime != null) {
      final startupTime = DateTime.now().difference(_playbackStartTime!);
      _telemetry?.recordStartup(
        channelId: _currentChannel?.id ?? '',
        channelName: _currentChannel?.name ?? '',
        startupTimeMs: startupTime.inMilliseconds,
      );
    }

    _transition(PlaybackPhase.playing, clearError: true);
  }

  void _onInternetStateChanged(InternetState internetState) {
    debugPrint('StateMachine: internet state → $internetState');

    if (internetState == InternetState.available) {
      // Internet restored
      if (_state.phase == PlaybackPhase.waitingForInternet) {
        debugPrint('StateMachine: internet restored — resuming playback');
        _retryManager.reset();
        _transition(PlaybackPhase.preparing, clearError: true);
        onRetryPlayback?.call();
      }
    } else if (internetState == InternetState.noInternet ||
               internetState == InternetState.dnsFailure) {
      // Internet lost during active playback
      if (_state.isActive && _state.phase != PlaybackPhase.waitingForInternet) {
        debugPrint('StateMachine: internet lost during active playback');
        _retryManager.cancel();
        _autoSkipManager.cancel();
        _bufferMonitor.stopMonitoring();
        _transition(PlaybackPhase.waitingForInternet,
          error: const ClassifiedError(
            type: ErrorType.noInternet,
            strategy: RecoveryStrategy.waitForInternet,
            rawMessage: 'Internet connection lost',
            isRecoverable: true,
          ),
        );
      }
    }
  }

  void _onBufferStalled(Duration stallDuration) {
    if (_state.phase != PlaybackPhase.buffering) return;

    debugPrint('StateMachine: buffer stalled for ${stallDuration.inSeconds}s');

    // Check internet first
    if (_connectivity.isOffline) {
      _transition(PlaybackPhase.waitingForInternet,
        error: const ClassifiedError(
          type: ErrorType.noInternet,
          strategy: RecoveryStrategy.waitForInternet,
          rawMessage: 'Internet connection lost while buffering',
          isRecoverable: true,
        ),
      );
      return;
    }

    // Treat stall as a retriable error
    _attemptRetry(ClassifiedError(
      type: ErrorType.cdnTimeout,
      strategy: RecoveryStrategy.retryWithBackoff,
      rawMessage: 'Stream stalled — no data received for ${stallDuration.inSeconds}s',
      isRecoverable: true,
    ));
  }

  // ─── State Transition ────────────────────────────────────────────

  void _transition(
    PlaybackPhase phase, {
    ClassifiedError? error,
    bool clearError = false,
  }) {
    final oldPhase = _state.phase;
    final shouldResetRetry = phase == PlaybackPhase.playing ||
        (phase == PlaybackPhase.preparing && oldPhase != PlaybackPhase.retrying);

    _state = _state.copyWith(
      phase: phase,
      error: error,
      clearError: clearError && error == null,
      retryAttempt: shouldResetRetry ? 0 : null,
      clearSkipCountdown: phase != PlaybackPhase.skipping,
    );

    debugPrint('StateMachine: $oldPhase → $phase');
    notifyListeners();
  }

  // ─── Cleanup ─────────────────────────────────────────────────────

  @override
  void dispose() {
    _internetSub?.cancel();
    _stallSub?.cancel();
    _retryManager.dispose();
    _bufferMonitor.dispose();
    _autoSkipManager.dispose();
    super.dispose();
  }
}
