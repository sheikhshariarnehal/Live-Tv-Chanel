import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../models/channel.dart';
import '../../services/local_proxy.dart';
import '../../services/playback/playback_state.dart';
import '../../services/playback/playback_state_machine.dart';
import '../../services/playback/connectivity_service.dart';
import '../../services/playback/playback_telemetry.dart';
import '../tv_focus_wrapper.dart';
import 'channel_video_player.dart';

Widget getChannelVideoPlayer({
  required Channel channel,
  VoidCallback? onFullscreenToggle,
  bool isFullscreen = false,
  bool showControls = true,
  VoidCallback? onTap,
  VoidCallback? onPreviousChannel,
  VoidCallback? onNextChannel,
  VoidCallback? onInteract,
}) {
  return ChannelVideoPlayerNative(
    channel: channel,
    onFullscreenToggle: onFullscreenToggle,
    isFullscreen: isFullscreen,
    showControls: showControls,
    onTap: onTap,
    onPreviousChannel: onPreviousChannel,
    onNextChannel: onNextChannel,
    onInteract: onInteract,
  );
}

class ChannelVideoPlayerNative extends StatefulWidget implements ChannelVideoPlayer {
  @override
  final Channel channel;
  @override
  final VoidCallback? onFullscreenToggle;
  @override
  final bool isFullscreen;
  @override
  final bool showControls;
  @override
  final VoidCallback? onTap;
  @override
  final VoidCallback? onPreviousChannel;
  @override
  final VoidCallback? onNextChannel;
  @override
  final VoidCallback? onInteract;

  const ChannelVideoPlayerNative({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
    this.showControls = true,
    this.onTap,
    this.onPreviousChannel,
    this.onNextChannel,
    this.onInteract,
  });

  @override
  State<ChannelVideoPlayerNative> createState() => _ChannelVideoPlayerNativeState();
}

class _ChannelVideoPlayerNativeState extends State<ChannelVideoPlayerNative> {
  MethodChannel? _methodChannel;
  bool _isPlaying = false;
  bool _isBuffering = true;
  bool _hasError = false;
  String? _errorMessage;

  // Cache creation params to avoid re-building on every frame
  Map<String, dynamic>? _cachedParams;
  String? _cachedChannelId;

  // Player state variables for controls
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  Duration _bufferedPosition = Duration.zero;
  Timer? _progressTimer;

  double _volume = 1.0;
  double _prevVolume = 1.0;
  bool _isMuted = false;

  // ignore: unused_field
  String _currentQuality = 'Auto';
  int _aspectRatioIndex = 0;
  bool _isLocked = false;
  bool _subtitlesEnabled = true;
  double _playbackSpeed = 1.0;

  final List<int> _resizeModes = [0, 3, 4]; // RESIZE_MODE_FIT, RESIZE_MODE_FILL, RESIZE_MODE_ZOOM
  final List<String> _aspectLabels = ['FIT', 'STRETCH', 'ZOOM'];

  static const _pipChannel = MethodChannel('com.goplay/pip');

  // ─── Playback State Machine ────────────────────────────────────

  late final PlaybackStateMachine _stateMachine;
  late final ConnectivityService _connectivityService;

  // ─── Pre-cached gradient decorations — allocated once, not per build() ──

  static final _kGradientOverlayFS = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withAlpha(200),
        Colors.transparent,
        Colors.transparent,
      ],
    ),
  );
  static final _kGradientOverlayPortrait = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.black.withAlpha(200),
        Colors.transparent,
        Colors.black.withAlpha(160),
      ],
    ),
  );

  // ─── Creation params ─────────────────────────────────────────────

  Map<String, dynamic> _getCreationParams() {
    if (_cachedParams != null && _cachedChannelId == widget.channel.id) {
      return _cachedParams!;
    }
    _cachedChannelId = widget.channel.id;
    _cachedParams = _buildCreationParams();
    return _cachedParams!;
  }

  Map<String, dynamic> _buildCreationParams() {
    final headers = widget.channel.headers.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    // Bypass local proxy — ExoPlayer's DefaultHttpDataSource.Factory
    // already propagates custom headers to all sub-requests (manifests,
    // segments, keys) natively.  Routing segments through the Dart heap
    // caused severe GC stalls (CollectNewGeneration up to 9.5 s).
    final playUrl = widget.channel.streamUrl;

    final params = <String, dynamic>{
      'url': playUrl,
      'headers': headers,
    };

    if (widget.channel.hasDrm) {
      final drm = widget.channel.drm!;
      params['drm_type'] = drm.type.name;

      if (drm.isClearKey) {
        if (drm.kid != null) params['drm_kid'] = drm.kid;
        if (drm.key != null) params['drm_key'] = drm.key;
        if (drm.clearKeys != null) params['drm_clearkeys'] = drm.clearKeys;
      } else if (drm.isWidevine) {
        if (drm.licenseUrl != null) params['drm_license_url'] = drm.licenseUrl;
        if (drm.licenseHeaders != null) params['drm_license_headers'] = drm.licenseHeaders;
      }
    }

    return params;
  }

  // ─── Platform view lifecycle ─────────────────────────────────────

  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('com.goplay/native_player_$id');
    _methodChannel!.setMethodCallHandler(_handleMethodCall);

    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.startKkx4Auth();
    }
  }

  // ─── Method call handler ─────────────────────────────────────────

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (!mounted) return;

    switch (call.method) {
      case 'onStateChanged':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final state = args['state'] as String;
        final isPlaying = args['isPlaying'] as bool? ?? false;
        final nowBuffering = state == 'buffering';
        final isReady = state == 'ready' || state == 'playing';

        // Delegate to state machine for recovery logic
        _stateMachine.handleNativeStateEvent(args);

        // Update local UI state for controls rendering
        if (_isPlaying != isPlaying || _isBuffering != nowBuffering ||
            (isReady && (_hasError || _errorMessage != null))) {
          setState(() {
            _isPlaying = isPlaying;
            _isBuffering = nowBuffering;
            if (isReady) {
              _hasError = false;
              _errorMessage = null;
            }
          });
        }

        if (isPlaying) {
          _startProgressTimer();
        } else {
          _stopProgressTimer();
        }
        _updateProgress();
        break;

      case 'onError':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final message = args['message'] as String? ?? 'Unknown playback error';
        debugPrint('NativePlayer error: $message');
        _stopProgressTimer();

        // Delegate to state machine — it will classify, retry, or skip
        _stateMachine.handleError(args);
        break;
    }
  }

  // ─── State Machine Listener ──────────────────────────────────────

  void _onStateMachineChanged() {
    if (!mounted) return;
    final smState = _stateMachine.state;

    // Sync error state from state machine into widget state
    switch (smState.phase) {
      case PlaybackPhase.failed:
        setState(() {
          _hasError = true;
          _errorMessage = smState.error?.userMessage ?? 'Unable to play this stream';
          _isBuffering = false;
        });
        break;

      case PlaybackPhase.waitingForInternet:
        setState(() {
          _hasError = true;
          _errorMessage = smState.error?.userMessage ?? 'No internet connection';
          _isBuffering = false;
        });
        break;

      case PlaybackPhase.retrying:
        // Show retrying state — not a hard error
        setState(() {
          _hasError = false;
          _isBuffering = true;
        });
        break;

      case PlaybackPhase.skipping:
        // Show skipping countdown — not a hard error
        setState(() {
          _hasError = false;
          _isBuffering = false;
        });
        break;

      case PlaybackPhase.preparing:
        setState(() {
          _hasError = false;
          _errorMessage = null;
          _isBuffering = true;
        });
        break;

      case PlaybackPhase.playing:
        setState(() {
          _hasError = false;
          _errorMessage = null;
        });
        break;

      default:
        break;
    }
  }

  // ─── Progress timer ──────────────────────────────────────────────

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && _isPlaying) {
        _updateProgress();
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  Future<void> _updateProgress() async {
    if (_methodChannel == null) return;
    try {
      final state = await _methodChannel!.invokeMethod<Map>('getState');
      if (state != null && mounted) {
        final newPlaying = state['isPlaying'] as bool? ?? _isPlaying;
        final newPos = Duration(milliseconds: (state['position'] as int? ?? 0));
        final newDur = Duration(milliseconds: (state['duration'] as int? ?? 0));
        final newBuf = Duration(milliseconds: (state['bufferedPosition'] as int? ?? 0));

        // Skip rebuild when controls are hidden AND position delta is <2s
        if (!widget.showControls &&
            newPlaying == _isPlaying &&
            (newPos - _position).abs() < const Duration(seconds: 2) &&
            newDur == _duration) {
          _isPlaying = newPlaying;
          _position = newPos;
          _duration = newDur;
          _bufferedPosition = newBuf;
          return;
        }

        // Skip rebuild if nothing actually changed
        if (newPlaying == _isPlaying &&
            newPos == _position &&
            newDur == _duration &&
            newBuf == _bufferedPosition) {
          return;
        }

        setState(() {
          _isPlaying = newPlaying;
          _position = newPos;
          _duration = newDur;
          _bufferedPosition = newBuf;
        });
      }
    } catch (e) {
      debugPrint('Error getting player state: $e');
    }
  }

  // ─── Playback controls ───────────────────────────────────────────

  void _retryPlaybackInternal() {
    _cachedParams = null;
    if (!mounted) return;
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isBuffering = true;
      _position = Duration.zero;
      _duration = Duration.zero;
      _bufferedPosition = Duration.zero;
    });
    _methodChannel?.invokeMethod('play', _getCreationParams());
  }

  /// Manual retry.
  void _retryPlayback() {
    _stateMachine.manualRetry();
  }

  void _seekTo(Duration position) {
    _methodChannel?.invokeMethod('seekTo', position.inMilliseconds);
    setState(() {
      _position = position;
    });
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
      _isMuted = value == 0.0;
    });
    _methodChannel?.invokeMethod('setVolume', value);
  }

  void _toggleMute() {
    if (_isMuted) {
      _setVolume(_prevVolume > 0 ? _prevVolume : 1.0);
    } else {
      _prevVolume = _volume;
      _setVolume(0.0);
    }
  }

  void _setQuality(String label, int height) {
    setState(() {
      _currentQuality = label;
    });
    _methodChannel?.invokeMethod('setQuality', height);
  }

  void _toggleAspectRatio() {
    setState(() {
      _aspectRatioIndex = (_aspectRatioIndex + 1) % _resizeModes.length;
    });
    final mode = _resizeModes[_aspectRatioIndex];
    _methodChannel?.invokeMethod('setResizeMode', mode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aspect Ratio: ${_aspectLabels[_aspectRatioIndex]}'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _enterPiP() async {
    try {
      await _pipChannel.invokeMethod('enterPiP');
    } catch (e) {
      debugPrint('Failed to enter PiP: $e');
    }
  }

  // ignore: unused_element
  void _toggleSubtitles() async {
    if (_methodChannel == null) return;
    try {
      final enabled = await _methodChannel!.invokeMethod<bool>('toggleSubtitles');
      if (enabled != null && mounted) {
        setState(() {
          _subtitlesEnabled = enabled;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_subtitlesEnabled ? 'Subtitles Enabled' : 'Subtitles Disabled'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling subtitles: $e');
    }
  }

  // ignore: unused_element
  void _cycleAudioTrack() async {
    if (_methodChannel == null) return;
    try {
      final lang = await _methodChannel!.invokeMethod<String>('cycleAudioTrack');
      if (lang != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang == "Default" || lang == "None"
                ? 'Audio Track: Default'
                : 'Audio Track Language: $lang'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error cycling audio track: $e');
    }
  }

  // ignore: unused_element
  void _cyclePlaybackSpeed() async {
    if (_methodChannel == null) return;
    final speeds = [1.0, 1.25, 1.5, 2.0, 0.5];
    final currentIdx = speeds.indexOf(_playbackSpeed);
    final nextSpeed = speeds[(currentIdx + 1) % speeds.length];
    try {
      final success = await _methodChannel!.invokeMethod<bool>('setPlaybackSpeed', nextSpeed);
      if (success == true && mounted) {
        setState(() {
          _playbackSpeed = nextSpeed;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Playback Speed: ${nextSpeed}x'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error setting playback speed: $e');
    }
  }

  void _showQualityMenu(TapDownDetails details) async {
    final position = details.globalPosition;

    List<int> qualities = [];
    try {
      if (_methodChannel != null) {
        final result = await _methodChannel!.invokeListMethod<int>('getVideoQualities');
        if (result != null) {
          qualities = result;
        }
      }
    } catch (e) {
      debugPrint('Error getting video qualities: $e');
    }

    if (qualities.isEmpty) {
      qualities = [1080, 720, 480, 360];
    }

    if (!mounted) return;

    final List<PopupMenuEntry<String>> menuItems = [
      PopupMenuItem<String>(
        value: 'Auto',
        child: Row(
          children: [
            Icon(
              Icons.check_rounded,
              color: _currentQuality == 'Auto' ? Colors.orange : Colors.transparent,
              size: 18,
            ),
            const SizedBox(width: 8),
            const Text(
              'Auto (Adaptive)',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(height: 1),
      ...qualities.map((q) {
        final label = '${q}p';
        final isSelected = _currentQuality == label;
        return PopupMenuItem<String>(
          value: label,
          child: Row(
            children: [
              Icon(
                Icons.check_rounded,
                color: isSelected ? Colors.orange : Colors.transparent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        );
      }),
    ];

    final messenger = ScaffoldMessenger.of(context);

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx - 60,
        position.dy - 200,
        position.dx + 60,
        position.dy,
      ),
      color: const Color(0xE61F1F23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12, width: 0.8),
      ),
      items: menuItems,
      elevation: 8,
    );

    if (selected != null && mounted) {
      int height = -1;
      if (selected != 'Auto') {
        height = int.tryParse(selected.replaceAll('p', '')) ?? -1;
      }
      _setQuality(selected, height);
      messenger.showSnackBar(
        SnackBar(
          content: Text('Quality set to: $selected'),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  String _formatDuration(Duration d) {
    final hrs = d.inHours;
    final mins = d.inMinutes.remainder(60);
    final secs = d.inSeconds.remainder(60);
    if (hrs > 0) {
      return '$hrs:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // ─── Widget lifecycle ────────────────────────────────────────────

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode(debugLabel: 'PlayerFocusNode');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    // Initialize the connectivity service and state machine
    _connectivityService = ConnectivityService();
    _connectivityService.initialize();

    _stateMachine = PlaybackStateMachine(
      connectivityService: _connectivityService,
      telemetry: PlaybackTelemetry(),
    );

    // Wire state machine callbacks
    _stateMachine.onRetryPlayback = _retryPlaybackInternal;
    _stateMachine.onSwitchChannel = (channelId) {
      if (widget.onNextChannel != null || widget.onPreviousChannel != null) {
        widget.onNextChannel?.call();
      }
    };
    _stateMachine.onSkipRequest = () {
      if (widget.onNextChannel != null) {
        debugPrint('PlayerWidget: skipping to next channel (immediate skip)');
        widget.onNextChannel!();
      } else if (widget.onPreviousChannel != null) {
        debugPrint('PlayerWidget: skipping to previous channel (immediate skip)');
        widget.onPreviousChannel!();
      } else {
        debugPrint('PlayerWidget: no next/prev channel to skip to — showing error screen');
        _stateMachine.forceFail(const ClassifiedError(
          type: ErrorType.unknown,
          strategy: RecoveryStrategy.showError,
          rawMessage: 'No adjacent channels available to skip to.',
          isRecoverable: false,
        ));
      }
    };

    // Listen for state machine changes
    _stateMachine.addListener(_onStateMachineChanged);

    // Tell the state machine about the initial channel
    _stateMachine.playChannel(widget.channel);
  }

  @override
  void didUpdateWidget(ChannelVideoPlayerNative oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id ||
        oldWidget.channel.streamUrl != widget.channel.streamUrl) {
      // Stop old Toffee auth timer if needed
      if (oldWidget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.stopKkx4Auth();
      }
      if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.startKkx4Auth();
      }

      // Tell state machine about the new channel
      _stateMachine.playChannel(widget.channel);

      _cachedParams = null;

      setState(() {
        _hasError = false;
        _errorMessage = null;
        _isBuffering = true;
        _position = Duration.zero;
        _duration = Duration.zero;
        _bufferedPosition = Duration.zero;
      });

      _methodChannel?.invokeMethod('play', _getCreationParams());
    }
  }

  Timer? _osdTimer;
  String? _osdText;
  IconData? _osdIcon;

  void _showOsd(String text, IconData icon) {
    _osdTimer?.cancel();
    if (mounted) {
      setState(() {
        _osdText = text;
        _osdIcon = icon;
      });
    }
    _osdTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _osdText = null;
          _osdIcon = null;
        });
      }
    });
  }

  void _seekRelative(int seconds) {
    final newPos = _position + Duration(seconds: seconds);
    final target = newPos < Duration.zero
        ? Duration.zero
        : (newPos > _duration ? _duration : newPos);
    _seekTo(target);
    _showOsd(
      seconds > 0 ? '+${seconds}s' : '${seconds}s',
      seconds > 0 ? Icons.fast_forward_rounded : Icons.fast_rewind_rounded,
    );
    if (!widget.showControls) {
      widget.onTap?.call();
    }
    widget.onInteract?.call();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _methodChannel?.invokeMethod('pause');
      _showOsd('Pause', Icons.pause_rounded);
    } else {
      _methodChannel?.invokeMethod('resume');
      _showOsd('Play', Icons.play_arrow_rounded);
    }
    if (!widget.showControls) {
      widget.onTap?.call();
    }
    widget.onInteract?.call();
  }

  KeyEventResult _handlePlayerKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.select ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.gameButtonA ||
          key == LogicalKeyboardKey.mediaPlayPause ||
          key == LogicalKeyboardKey.mediaPlay ||
          key == LogicalKeyboardKey.mediaPause) {
        _togglePlayPause();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.mediaRewind ||
          key == LogicalKeyboardKey.mediaStepBackward) {
        _seekRelative(-10);
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.mediaFastForward ||
          key == LogicalKeyboardKey.mediaStepForward) {
        _seekRelative(10);
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.channelUp) {
        if (widget.onPreviousChannel != null) {
          _showOsd('Previous Channel', Icons.skip_previous_rounded);
          widget.onPreviousChannel!();
          return KeyEventResult.handled;
        }
      }
      if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.channelDown) {
        if (widget.onNextChannel != null) {
          _showOsd('Next Channel', Icons.skip_next_rounded);
          widget.onNextChannel!();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _osdTimer?.cancel();
    _stopProgressTimer();
    _focusNode.dispose();
    _stateMachine.removeListener(_onStateMachineChanged);
    _stateMachine.dispose();
    _connectivityService.dispose();
    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.stopKkx4Auth();
    }
    _methodChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  // ─── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorWidget();

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handlePlayerKeyEvent,
      child: ColoredBox(
        color: Colors.black,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Native ExoPlayer view — disabled from taking D-Pad focus
              Focus(
                canRequestFocus: false,
                child: AndroidView(
                  viewType: 'com.goplay/native_player',
                  creationParams: _getCreationParams(),
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: _onPlatformViewCreated,
                ),
              ),

              // Buffering indicator (isolated — when controls are hidden)
              if (_isBuffering && !widget.showControls)
                const Center(
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),

              // Tap overlay to show/hide controls
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onTap,
                  child: const SizedBox.shrink(),
                ),
              ),

              // Controls UI layer
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !widget.showControls,
                  child: Listener(
                    onPointerDown: (_) {
                      widget.onInteract?.call();
                    },
                    child: AnimatedOpacity(
                      opacity: widget.showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _isLocked
                          ? _buildLockedControls()
                          : _buildUnlockedControls(),
                    ),
                  ),
                ),
              ),

              // ── State machine status overlay ──
              Positioned(
                left: 0,
                right: 0,
                bottom: widget.isFullscreen ? 80 : 56,
                child: Center(
                  child: _StateMachineOverlay(stateMachine: _stateMachine),
                ),
              ),

              // ── Android TV Remote OSD Feedback ──
              Positioned.fill(
                child: IgnorePointer(
                  child: _TvPlayerOsd(
                    message: _osdText,
                    icon: _osdIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Locked controls ─────────────────────────────────────────────

  Widget _buildLockedControls() {
    return Stack(
      children: [
        Positioned(
          left: widget.isFullscreen ? 24 : 12,
          bottom: widget.isFullscreen ? 24 : 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isLocked = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white30, width: 1.0),
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Unlocked controls ───────────────────────────────────────────

  Widget _buildUnlockedControls() {
    return Stack(
      children: [
        // Dark gradient overlay — pre-cached decorations
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: DecoratedBox(
              decoration: widget.isFullscreen
                  ? _kGradientOverlayFS
                  : _kGradientOverlayPortrait,
            ),
          ),
        ),

        // Central Playback Controls — isolated from seek-bar repaints
        Center(
          child: RepaintBoundary(
            child: _CentralControls(
              isPlaying: _isPlaying,
              isBuffering: _isBuffering,
              onPlayPause: () {
                if (_isPlaying) {
                  _methodChannel?.invokeMethod('pause');
                } else {
                  _methodChannel?.invokeMethod('resume');
                }
              },
              onPrev: widget.onPreviousChannel,
              onNext: widget.onNextChannel,
              onRewind: () {
                final newPos = _position - const Duration(seconds: 10);
                _seekTo(newPos < Duration.zero ? Duration.zero : newPos);
              },
              onForward: () {
                final newPos = _position + const Duration(seconds: 10);
                _seekTo(newPos > _duration ? _duration : newPos);
              },
              isFullscreen: widget.isFullscreen,
            ),
          ),
        ),

        // Bottom Controls Bar — isolated from central controls repaints
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(217),
                    Colors.black.withAlpha(140),
                    Colors.black.withAlpha(51),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 0.8, 1.0],
                ),
              ),
              padding: EdgeInsets.only(
                top: widget.isFullscreen ? 16.0 : 4.0,
                bottom: widget.isFullscreen ? 8.0 : 0.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Seek Bar / Timeline
                  RepaintBoundary(
                    child: PlayerProgressBar(
                      position: _position,
                      duration: _duration,
                      bufferedPosition: _bufferedPosition,
                      onSeek: _seekTo,
                      isFullscreen: widget.isFullscreen,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Bottom Buttons row
                  Padding(
                    padding: EdgeInsets.only(
                      left: widget.isFullscreen ? 24.0 : 12.0,
                      right: widget.isFullscreen ? 24.0 : 12.0,
                      bottom: widget.isFullscreen ? 12.0 : 0.0,
                      top: 0.0,
                    ),
                    child: Row(
                      children: [
                        // Time text
                        Text(
                          '${_formatDuration(_position)} · ${_formatDuration(_duration)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const Spacer(),

                        if (widget.isFullscreen)
                          _buildFullscreenRightControls()
                        else
                          _buildPortraitRightControls(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullscreenRightControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Aspect Ratio Button
        TvFocusable(
          isCircle: true,
          onTap: _toggleAspectRatio,
          child: IconButton(
            onPressed: _toggleAspectRatio,
            icon: const Icon(Icons.fit_screen, color: Colors.white),
            iconSize: 28,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            tooltip: _aspectLabels[_aspectRatioIndex],
          ),
        ),
        const SizedBox(width: 4),
        // Volume Button
        TvFocusable(
          isCircle: true,
          onTap: _toggleMute,
          child: IconButton(
            onPressed: _toggleMute,
            icon: Icon(
              _isMuted || _volume == 0
                  ? Icons.volume_off
                  : (_volume < 0.5 ? Icons.volume_down : Icons.volume_up),
              color: Colors.white,
            ),
            iconSize: 28,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 4),
        // Lock Button
        TvFocusable(
          isCircle: true,
          onTap: () {
            setState(() {
              _isLocked = true;
            });
          },
          child: IconButton(
            onPressed: () {
              setState(() {
                _isLocked = true;
              });
            },
            icon: const Icon(Icons.lock_open, color: Colors.white),
            iconSize: 28,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 4),
        // PiP Button
        TvFocusable(
          isCircle: true,
          onTap: _enterPiP,
          child: IconButton(
            onPressed: _enterPiP,
            icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
            iconSize: 28,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 4),
        // Settings / Quality Button
        TvFocusable(
          isCircle: true,
          onTap: () {
            final renderBox = context.findRenderObject() as RenderBox?;
            final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
            _showQualityMenu(TapDownDetails(globalPosition: offset));
          },
          child: IconButton(
            onPressed: () {
              final renderBox = context.findRenderObject() as RenderBox?;
              final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
              _showQualityMenu(TapDownDetails(globalPosition: offset));
            },
            icon: const Icon(Icons.settings, color: Colors.white),
            iconSize: 28,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
          ),
        ),
        const SizedBox(width: 4),
        // Fullscreen Toggle Button
        if (widget.onFullscreenToggle != null)
          TvFocusable(
            isCircle: true,
            onTap: widget.onFullscreenToggle,
            child: IconButton(
              onPressed: widget.onFullscreenToggle,
              icon: Icon(
                widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
              iconSize: 28,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }

  Widget _buildPortraitRightControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Volume Button
        IconButton(
          onPressed: _toggleMute,
          icon: Icon(
            _isMuted || _volume == 0
                ? Icons.volume_off
                : (_volume < 0.5 ? Icons.volume_down : Icons.volume_up),
            color: Colors.white,
          ),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(),
        ),
        // Settings Button
        GestureDetector(
          onTapDown: (details) => _showQualityMenu(details),
          behavior: HitTestBehavior.opaque,
          child: IgnorePointer(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings, color: Colors.white),
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        // PiP Button
        IconButton(
          onPressed: _enterPiP,
          icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(),
        ),
        // Fullscreen Toggle Button
        if (widget.onFullscreenToggle != null)
          IconButton(
            onPressed: widget.onFullscreenToggle,
            icon: Icon(
              widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  // ─── Error widget (state-machine aware) ───────────────────────────

  Widget _buildErrorWidget() {
    final smState = _stateMachine.state;
    final errorType = smState.error?.type;
    final isDrm = errorType == ErrorType.drmFailure || widget.channel.hasDrm;
    final isNoInternet = errorType == ErrorType.noInternet ||
        smState.phase == PlaybackPhase.waitingForInternet;
    final isGeoBlock = errorType == ErrorType.geoBlock;
    final hasNext = widget.onNextChannel != null;
    final hasPrev = widget.onPreviousChannel != null;

    // Choose icon based on error type
    IconData errorIcon;
    Color iconColor;
    String errorTitle;

    if (isNoInternet) {
      errorIcon = Icons.wifi_off_rounded;
      iconColor = Colors.orange;
      errorTitle = 'No Internet Connection';
    } else if (isDrm) {
      errorIcon = Icons.lock_outline;
      iconColor = Colors.orange;
      errorTitle = 'DRM Protected Content';
    } else if (isGeoBlock) {
      errorIcon = Icons.shield_outlined;
      iconColor = Colors.redAccent;
      errorTitle = 'Content Not Available';
    } else {
      errorIcon = Icons.signal_wifi_statusbar_connected_no_internet_4_rounded;
      iconColor = Colors.redAccent;
      errorTitle = 'Stream Unavailable';
    }

    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(errorIcon, color: iconColor, size: 48),
              const SizedBox(height: 14),
              Text(
                errorTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.channel.name,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage ?? 'Unable to play this stream',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20),
              // Action buttons row
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  // Retry button
                  _ErrorActionButton(
                    icon: Icons.refresh_rounded,
                    label: isNoInternet ? 'Check Connection' : 'Retry',
                    onTap: _retryPlayback,
                    isPrimary: true,
                  ),
                  // Next Channel button
                  if (hasNext)
                    _ErrorActionButton(
                      icon: Icons.skip_next_rounded,
                      label: 'Next Channel',
                      onTap: () {
                        widget.onNextChannel!();
                      },
                      isPrimary: false,
                    ),
                  // Previous Channel button (fallback if no next)
                  if (!hasNext && hasPrev)
                    _ErrorActionButton(
                      icon: Icons.skip_previous_rounded,
                      label: 'Prev Channel',
                      onTap: () {
                        widget.onPreviousChannel!();
                      },
                      isPrimary: false,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── Error Action Button ─────────────────────────────────────────

class _ErrorActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ErrorActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: isPrimary ? Colors.white : Colors.white70,
        backgroundColor: isPrimary
            ? Colors.orange.shade800
            : Colors.white.withAlpha(25),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : const BorderSide(color: Colors.white24, width: 0.8),
        ),
      ),
    );
  }
}

// ─── State Machine Status Overlay ─────────────────────────────────

/// Shows contextual overlays based on the [PlaybackStateMachine] state:
/// - Retrying: "Retrying (2/3)..."
/// - Skipping: "Skipping in 5s... [Cancel] [Skip Now]"
/// - Waiting for Internet: "Waiting for internet..."
class _StateMachineOverlay extends StatelessWidget {
  final PlaybackStateMachine stateMachine;

  const _StateMachineOverlay({required this.stateMachine});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: stateMachine,
      builder: (context, _) {
        final state = stateMachine.state;

        switch (state.phase) {
          case PlaybackPhase.retrying:
            return _StatusPill(
              icon: Icons.refresh_rounded,
              iconColor: Colors.orangeAccent,
              message: 'Retrying (${state.retryAttempt}/${state.maxRetries})…',
              showSpinner: true,
            );

          case PlaybackPhase.skipping:
            return _SkipCountdownPill(
              secondsRemaining: state.skipCountdown ?? 0,
              onCancel: () => stateMachine.cancelSkip(),
              onSkipNow: () => stateMachine.skipNow(),
            );

          case PlaybackPhase.waitingForInternet:
            return const _StatusPill(
              icon: Icons.wifi_off_rounded,
              iconColor: Colors.orange,
              message: 'Waiting for internet…',
              showSpinner: true,
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

/// Simple status pill with icon/spinner + message.
class _StatusPill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final bool showSpinner;

  const _StatusPill({
    required this.icon,
    required this.iconColor,
    required this.message,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSpinner)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                strokeWidth: 1.5,
              ),
            )
          else
            Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Skip countdown pill with [Cancel] and [Skip Now] buttons.
class _SkipCountdownPill extends StatelessWidget {
  final int secondsRemaining;
  final VoidCallback onCancel;
  final VoidCallback onSkipNow;

  const _SkipCountdownPill({
    required this.secondsRemaining,
    required this.onCancel,
    required this.onSkipNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(210),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withAlpha(100), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
              strokeWidth: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Skipping in ${secondsRemaining}s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onCancel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white38, width: 0.8),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSkipNow,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Skip Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─── Central Playback Controls ────────────────────────────────────

/// Extracted central playback controls (prev, rewind, play/pause, forward, next)
class _CentralControls extends StatelessWidget {
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onRewind;
  final VoidCallback onForward;
  final bool isFullscreen;

  const _CentralControls({
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayPause,
    required this.onPrev,
    required this.onNext,
    required this.onRewind,
    required this.onForward,
    required this.isFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = isFullscreen ? 34 : 24;
    final double playSize = isFullscreen ? 60 : 44;
    final double spacing = isFullscreen ? 20 : 12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onPrev != null)
          TvFocusable(
            isCircle: true,
            onTap: onPrev,
            child: IconButton(
              onPressed: onPrev,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.skip_previous_rounded,
                color: Colors.white,
              ),
              iconSize: iconSize,
            ),
          ),
        if (onPrev != null) SizedBox(width: spacing),
        TvFocusable(
          isCircle: true,
          onTap: onRewind,
          child: IconButton(
            onPressed: onRewind,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
            iconSize: iconSize,
          ),
        ),
        SizedBox(width: spacing),
        TvFocusable(
          isCircle: true,
          onTap: onPlayPause,
          child: Container(
            width: playSize,
            height: playSize,
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isBuffering
                  ? SizedBox(
                      width: playSize * 0.5,
                      height: playSize * 0.5,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: isFullscreen ? 2.5 : 2.0,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: playSize * 0.75,
                    ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        TvFocusable(
          isCircle: true,
          onTap: onForward,
          child: IconButton(
            onPressed: onForward,
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
            iconSize: iconSize,
          ),
        ),
        if (onNext != null) SizedBox(width: spacing),
        if (onNext != null)
          TvFocusable(
            isCircle: true,
            onTap: onNext,
            child: IconButton(
              onPressed: onNext,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.skip_next_rounded,
                color: Colors.white,
              ),
              iconSize: iconSize,
            ),
          ),
      ],
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────

/// Custom Seek Bar ProgressBar with Buffer Indicator
class PlayerProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onSeek;
  final bool isFullscreen;

  const PlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.onSeek,
    required this.isFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) {
      return const SizedBox(height: 12);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: isFullscreen ? 2.0 : 0.0,
      ),
      child: Builder(
        builder: (innerContext) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              _handleDrag(innerContext, details.localPosition.dx);
            },
            onTapDown: (details) {
              _handleDrag(innerContext, details.localPosition.dx);
            },
            child: SizedBox(
              height: 10,
              width: double.infinity,
              child: CustomPaint(
                painter: _ProgressBarPainter(
                  position: position,
                  duration: duration,
                  bufferedPosition: bufferedPosition,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleDrag(BuildContext context, double localX) {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && duration > Duration.zero) {
      final width = box.size.width;
      final pct = (localX / width).clamp(0.0, 1.0);
      final targetMs = (duration.inMilliseconds * pct).round();
      onSeek(Duration(milliseconds: targetMs));
    }
  }
}

class _ProgressBarPainter extends CustomPainter {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;

  // Pre-computed percentages — avoids floating-point division inside paint()
  final double _posPct;
  final double _bufPct;

  // Cached Paint objects — allocated once, not per paint() call
  static final _paintBg    = Paint()..color = Colors.white12;
  static final _paintBuf   = Paint()..color = Colors.white30;
  static final _paintAct   = Paint()..color = Colors.white;
  static final _paintThumb = Paint()..color = Colors.white;

  _ProgressBarPainter({
    required this.position,
    required this.duration,
    required this.bufferedPosition,
  })  : _posPct = duration.inMilliseconds > 0
            ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0,
        _bufPct = duration.inMilliseconds > 0
            ? (bufferedPosition.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    const h = 2.0;
    const r = Radius.circular(h / 2);

    // Background track
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, y - h / 2, size.width, h), r),
      _paintBg,
    );

    if (duration == Duration.zero) return;

    // Buffered track
    if (_bufPct > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, y - h / 2, size.width * _bufPct, h), r),
        _paintBuf,
      );
    }

    // Played track
    if (_posPct > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, y - h / 2, size.width * _posPct, h), r),
        _paintAct,
      );
    }

    // Thumb handle
    canvas.drawCircle(Offset(size.width * _posPct, y), 4.5, _paintThumb);
  }

  @override
  bool shouldRepaint(covariant _ProgressBarPainter old) {
    return old.position != position ||
        old.duration != duration ||
        old.bufferedPosition != bufferedPosition;
  }
}

class _TvPlayerOsd extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const _TvPlayerOsd({this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: GoPlayTheme.primary.withValues(alpha: 0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: GoPlayTheme.primary.withValues(alpha: 0.3),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: GoPlayTheme.primary, size: 24),
            if (icon != null) const SizedBox(width: 10),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
