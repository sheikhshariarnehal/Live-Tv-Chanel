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
}) {
  return ChannelVideoPlayerNative(
    channel: channel,
    onFullscreenToggle: onFullscreenToggle,
    isFullscreen: isFullscreen,
    showControls: showControls,
    onTap: onTap,
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

  const ChannelVideoPlayerNative({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
    this.showControls = true,
    this.onTap,
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

        setState(() {
          _isPlaying = isPlaying;
          _isBuffering = state == 'buffering';
          if (state == 'ready' || state == 'playing') {
            _hasError = false;
            _errorMessage = null;
          }
        });
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
        break;
    }
  }

  void _retryPlayback() {
    _cachedParams = null; // Invalidate cache on retry
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isBuffering = true;
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
      });

      _methodChannel?.invokeMethod('play', _getCreationParams());
    }
  }

  @override
  void dispose() {
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

            // Buffering indicator (isolated)
            if (_isBuffering)
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

            // Tap overlay
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                child: const SizedBox.shrink(),
              ),
            ),

            // Controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: !widget.showControls,
                child: AnimatedOpacity(
                  opacity: widget.showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: _PlayerControls(
                    isPlaying: _isPlaying,
                    isFullscreen: widget.isFullscreen,
                    hasDrm: widget.channel.hasDrm,
                    onPlayPause: () {
                      if (_isPlaying) {
                        _methodChannel?.invokeMethod('pause');
                      } else {
                        _methodChannel?.invokeMethod('resume');
                      }
                    },
                    onFullscreenToggle: widget.onFullscreenToggle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

/// Extracted controls bar — avoids rebuilding when only play/pause state changes.
class _PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isFullscreen;
  final bool hasDrm;
  final VoidCallback onPlayPause;
  final VoidCallback? onFullscreenToggle;

  const _PlayerControls({
    required this.isPlaying,
    required this.isFullscreen,
    required this.hasDrm,
    required this.onPlayPause,
    this.onFullscreenToggle,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xB4000000), Colors.transparent],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: isFullscreen ? 14.0 : 6.0,
          right: isFullscreen ? 14.0 : 6.0,
          top: 4,
          bottom: isFullscreen ? 12.0 : 4.0,
        ),
        child: Row(
          children: [
            // Play / Pause
            IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              iconSize: 26,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),

            // LIVE badge
            const _LiveIndicator(),

            // DRM indicator
            if (hasDrm) ...[
              const SizedBox(width: 5),
              const _DrmIndicator(),
            ],

            const Spacer(),

            // Fullscreen toggle
            if (onFullscreenToggle != null)
              IconButton(
                onPressed: onFullscreenToggle,
                icon: Icon(
                  isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                iconSize: 24,
                padding: const EdgeInsets.all(6),
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 6, height: 6,
              child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            ),
            SizedBox(width: 4),
            Text(
              'LIVE',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrmIndicator extends StatelessWidget {
  const _DrmIndicator();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xB4FF9800),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, color: Colors.white, size: 8),
            SizedBox(width: 3),
            Text(
              'DRM',
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
