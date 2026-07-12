// Immutable state definitions for the playback state machine.
//
// This file defines all possible playback phases and the immutable state
// object that flows through the system. No boolean flag spaghetti — every
// possible player condition is expressed as a single [PlaybackPhase].

/// All possible phases the player can be in.
enum PlaybackPhase {
  /// No channel loaded.
  idle,

  /// Resolving URL, building media source.
  preparing,

  /// Waiting for first server response.
  connecting,

  /// Receiving data, building buffer.
  buffering,

  /// Active healthy playback.
  playing,

  /// Active recovery attempt after failure.
  retrying,

  /// Device offline, paused, waiting for connectivity.
  waitingForInternet,

  /// Auto-advancing to next channel (countdown active).
  skipping,

  /// Unrecoverable error, user action required.
  failed,
}

/// Typed error categories produced by [ErrorClassifier].
enum ErrorType {
  noInternet,
  slowNetwork,
  cdnTimeout,
  serverError,
  deadStream,
  authExpired,
  drmFailure,
  geoBlock,
  unknown,
}

/// The recovery action the system should take for a given error.
enum RecoveryStrategy {
  /// Pause and wait for internet to come back. Never skip.
  waitForInternet,

  /// Keep buffering — data is arriving, just slowly.
  keepBuffering,

  /// Retry playback with exponential backoff.
  retryWithBackoff,

  /// Refresh authentication token, then retry once.
  refreshAuth,

  /// Refresh DRM license, then retry once.
  refreshDrm,

  /// Skip to the next channel (after countdown).
  skip,

  /// Show error to user, require manual action.
  showError,
}

/// A classified error with structured metadata.
class ClassifiedError {
  final ErrorType type;
  final RecoveryStrategy strategy;
  final String rawMessage;
  final int? httpStatus;
  final int? exoErrorCode;
  final String? exoErrorCodeName;
  final bool isRecoverable;

  const ClassifiedError({
    required this.type,
    required this.strategy,
    required this.rawMessage,
    this.httpStatus,
    this.exoErrorCode,
    this.exoErrorCodeName,
    this.isRecoverable = true,
  });

  /// User-facing description of the error.
  String get userMessage {
    switch (type) {
      case ErrorType.noInternet:
        return 'No internet connection';
      case ErrorType.slowNetwork:
        return 'Slow network — buffering';
      case ErrorType.cdnTimeout:
        return 'Server not responding';
      case ErrorType.serverError:
        return 'Server error';
      case ErrorType.deadStream:
        return 'Stream unavailable';
      case ErrorType.authExpired:
        return 'Authentication expired';
      case ErrorType.drmFailure:
        return 'DRM license error';
      case ErrorType.geoBlock:
        return 'Content not available in your region';
      case ErrorType.unknown:
        return 'Playback error';
    }
  }

  @override
  String toString() =>
      'ClassifiedError(type: $type, strategy: $strategy, http: $httpStatus, '
      'exo: $exoErrorCode/$exoErrorCodeName, msg: $rawMessage)';
}

/// Immutable snapshot of the full playback state.
///
/// The [PlaybackStateMachine] produces new instances of this class on every
/// state transition. Widgets observe changes via [ChangeNotifier] and rebuild
/// only the parts of the UI affected by the transition.
class PlaybackState {
  final PlaybackPhase phase;
  final String? channelId;
  final ClassifiedError? error;
  final int retryAttempt;
  final int maxRetries;
  final int? skipCountdown;
  final double bufferProgress;
  final bool isBufferGrowing;

  const PlaybackState({
    this.phase = PlaybackPhase.idle,
    this.channelId,
    this.error,
    this.retryAttempt = 0,
    this.maxRetries = 3,
    this.skipCountdown,
    this.bufferProgress = 0.0,
    this.isBufferGrowing = false,
  });

  PlaybackState copyWith({
    PlaybackPhase? phase,
    String? channelId,
    ClassifiedError? error,
    bool clearError = false,
    int? retryAttempt,
    int? maxRetries,
    int? skipCountdown,
    bool clearSkipCountdown = false,
    double? bufferProgress,
    bool? isBufferGrowing,
  }) {
    return PlaybackState(
      phase: phase ?? this.phase,
      channelId: channelId ?? this.channelId,
      error: clearError ? null : (error ?? this.error),
      retryAttempt: retryAttempt ?? this.retryAttempt,
      maxRetries: maxRetries ?? this.maxRetries,
      skipCountdown: clearSkipCountdown ? null : (skipCountdown ?? this.skipCountdown),
      bufferProgress: bufferProgress ?? this.bufferProgress,
      isBufferGrowing: isBufferGrowing ?? this.isBufferGrowing,
    );
  }

  /// Whether the player is in an active playback-related phase
  /// (not idle, not failed).
  bool get isActive =>
      phase != PlaybackPhase.idle && phase != PlaybackPhase.failed;

  /// Whether the UI should show a loading/connecting indicator.
  bool get isLoading =>
      phase == PlaybackPhase.preparing ||
      phase == PlaybackPhase.connecting;

  /// Whether the UI should show a retry status overlay.
  bool get isRetrying => phase == PlaybackPhase.retrying;

  /// Whether the UI should show a skip countdown.
  bool get isSkipping => phase == PlaybackPhase.skipping;

  /// Whether the UI should show the "waiting for internet" state.
  bool get isWaitingForInternet => phase == PlaybackPhase.waitingForInternet;

  @override
  String toString() =>
      'PlaybackState(phase: $phase, ch: $channelId, retry: $retryAttempt/$maxRetries, '
      'skip: $skipCountdown, buffer: ${bufferProgress.toStringAsFixed(1)}%, '
      'growing: $isBufferGrowing, error: ${error?.type})';
}
