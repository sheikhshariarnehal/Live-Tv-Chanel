import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/channel.dart';
import '../../services/local_proxy.dart';
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

    var playUrl = widget.channel.streamUrl;
    if (widget.channel.proxy) {
      playUrl = LocalProxy.getUrl(playUrl, widget.channel.headers);
    }

    final params = <String, dynamic>{
      'url': playUrl,
      'headers': headers,
    };

    // Add DRM configuration if present
    if (widget.channel.hasDrm) {
      final drm = widget.channel.drm!;
      params['drm_type'] = drm.type.name;

      if (drm.isClearKey) {
        if (drm.kid != null) params['drm_kid'] = drm.kid;
        if (drm.key != null) params['drm_key'] = drm.key;
        if (drm.clearKeys != null) {
          params['drm_clearkeys'] = drm.clearKeys;
        }
      } else if (drm.isWidevine) {
        if (drm.licenseUrl != null) params['drm_license_url'] = drm.licenseUrl;
        if (drm.licenseHeaders != null) params['drm_license_headers'] = drm.licenseHeaders;
      }
    }

    return params;
  }

  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('com.goplay/native_player_$id');
    _methodChannel!.setMethodCallHandler(_handleMethodCall);

    // Trigger Toffee IP authorization if needed
    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.startKkx4Auth();
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (!mounted) return;

    switch (call.method) {
      case 'onStateChanged':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final state = args['state'] as String;
        final isPlaying = args['isPlaying'] as bool? ?? false;
        final nowBuffering = state == 'buffering';
        final isReady = state == 'ready' || state == 'playing';

        // Only rebuild if state actually changed
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

        setState(() {
          _hasError = true;
          _errorMessage = message;
          _isBuffering = false;
        });
        _stopProgressTimer();
        break;
    }
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    // 500 ms is sufficient for IPTV/live streams and halves MethodChannel overhead
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
        // (the seek bar is invisible, so no visual update needed)
        if (!widget.showControls &&
            newPlaying == _isPlaying &&
            (newPos - _position).abs() < const Duration(seconds: 2) &&
            newDur == _duration) {
          // Still update internal state for when controls reappear
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
            content: Text(lang == "Default" || lang == "None" ? 'Audio Track: Default' : 'Audio Track Language: $lang'),
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
    
    // Fetch dynamic qualities from ExoPlayer
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

    // Fallback list of default qualities if none are auto-detected (e.g. static HLS metadata or single stream)
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

    // Capture scaffold messenger before showMenu future resolves
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

  void _retryPlayback() {
    _cachedParams = null; // Invalidate cache on retry
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

  @override
  void didUpdateWidget(ChannelVideoPlayerNative oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id ||
        oldWidget.channel.streamUrl != widget.channel.streamUrl) {
      // Stop old Toffee auth timer if needed
      if (oldWidget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.stopKkx4Auth();
      }
      // Start new Toffee auth timer if needed
      if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
        LocalProxy.startKkx4Auth();
      }

      _cachedParams = null; // Invalidate on channel switch

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

  @override
  void dispose() {
    _stopProgressTimer();
    if (widget.channel.streamUrl.contains('otte.cache.aiv-cdn.net')) {
      LocalProxy.stopKkx4Auth();
    }
    _methodChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _buildErrorWidget();

    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Native ExoPlayer view
            AndroidView(
              viewType: 'com.goplay/native_player',
              creationParams: _getCreationParams(),
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),

            // Buffering indicator (isolated/standalone - when controls are hidden)
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
          ],
        ),
      ),
    );
  }

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
                border: Border.fromBorderSide(BorderSide(color: Colors.white30, width: 1.0)),
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

  Widget _buildUnlockedControls() {
    return Stack(
      children: [
        // Dark gradient overlay top and bottom
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(200),
                    Colors.transparent,
                    widget.isFullscreen ? Colors.transparent : Colors.black.withAlpha(160),
                  ],
                ),
              ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seek Bar / Timeline — isolated from time-text repaints
                RepaintBoundary(
                  child: PlayerProgressBar(
                    position: _position,
                    duration: _duration,
                    bufferedPosition: _bufferedPosition,
                    onSeek: _seekTo,
                  ),
                ),

                // Bottom Buttons row
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.isFullscreen ? 24.0 : 12.0,
                    right: widget.isFullscreen ? 24.0 : 12.0,
                    bottom: widget.isFullscreen ? 20.0 : 8.0,
                    top: widget.isFullscreen ? 4.0 : 2.0,
                  ),
                  child: Row(
                    children: [
                      // Time text
                      Text(
                        '${_formatDuration(_position)} · ${_formatDuration(_duration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const Spacer(),

                      // Lock and right controls
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
      ],
    );
  }

  Widget _buildFullscreenRightControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 2. Aspect Ratio Button
        IconButton(
          onPressed: _toggleAspectRatio,
          icon: const Icon(Icons.fit_screen, color: Colors.white),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(),
          tooltip: _aspectLabels[_aspectRatioIndex],
        ),
        // 4. Volume Button
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
        // 5. Lock Button
        IconButton(
          onPressed: () {
            setState(() {
              _isLocked = true;
            });
          },
          icon: const Icon(Icons.lock_open, color: Colors.white),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(),
        ),
        // 7. PiP Button
        IconButton(
          onPressed: _enterPiP,
          icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          constraints: const BoxConstraints(),
        ),
        // 9. Settings / Quality Button
        GestureDetector(
          onTapDown: (details) => _showQualityMenu(details),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        // 11. Fullscreen Toggle Button
        if (widget.onFullscreenToggle != null)
          IconButton(
            onPressed: widget.onFullscreenToggle,
            icon: Icon(
              widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            iconSize: 26,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildPortraitRightControls() {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        ),
        // Settings Button
        GestureDetector(
          onTapDown: (details) => _showQualityMenu(details),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        // PiP Button
        IconButton(
          onPressed: _enterPiP,
          icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
          iconSize: 24,
        ),
        // Fullscreen Toggle Button
        if (widget.onFullscreenToggle != null)
          IconButton(
            onPressed: widget.onFullscreenToggle,
            icon: Icon(
              widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
            iconSize: 26,
          ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    final isDrm = widget.channel.hasDrm;
    return ColoredBox(
      color: Colors.black,
      child: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDrm ? Icons.lock_outline : Icons.error_outline,
                color: isDrm ? Colors.orange : Colors.redAccent,
                size: 44,
              ),
              const SizedBox(height: 14),
              Text(
                isDrm ? 'DRM Protected Content' : 'Playback Error',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage ?? 'Unable to play this stream',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: _retryPlayback,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: Icon(
            Icons.skip_previous_rounded,
            color: onPrev != null ? Colors.white : Colors.white24,
          ),
          iconSize: 34,
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: onRewind,
          icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
          iconSize: 34,
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isBuffering
                  ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 38,
                    ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: onForward,
          icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
          iconSize: 34,
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: onNext,
          icon: Icon(
            Icons.skip_next_rounded,
            color: onNext != null ? Colors.white : Colors.white24,
          ),
          iconSize: 34,
        ),
      ],
    );
  }
}

/// Custom Seek Bar ProgressBar with Buffer Indicator
class PlayerProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onSeek;

  const PlayerProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) {
      return const SizedBox(height: 12);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        _handleDrag(context, details.localPosition.dx);
      },
      onTapDown: (details) {
        _handleDrag(context, details.localPosition.dx);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 12,
          width: double.infinity,
          child: CustomPaint(
            painter: _ProgressBarPainter(
              position: position,
              duration: duration,
              bufferedPosition: bufferedPosition,
            ),
          ),
        ),
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
        RRect.fromRectAndRadius(Rect.fromLTWH(0, y - h / 2, size.width * _bufPct, h), r),
        _paintBuf,
      );
    }

    // Played track
    if (_posPct > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, y - h / 2, size.width * _posPct, h), r),
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
