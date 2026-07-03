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

  /// Build the creation parameters to pass to the native ExoPlayer view.
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

  /// Handle callbacks from the native ExoPlayer.
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onStateChanged':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final state = args['state'] as String;
        final isPlaying = args['isPlaying'] as bool? ?? false;

        if (mounted) {
          setState(() {
            _isPlaying = isPlaying;
            _isBuffering = state == 'buffering';
            if (state == 'ready' || state == 'playing') {
              _hasError = false;
              _errorMessage = null;
            }
          });
        }
        break;

      case 'onError':
        final args = Map<String, dynamic>.from(call.arguments as Map);
        final message = args['message'] as String? ?? 'Unknown playback error';
        debugPrint('NativePlayer error: $message');

        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = message;
            _isBuffering = false;
          });
        }
        break;
    }
  }

  void _retryPlayback() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isBuffering = true;
    });

    // Re-send play command with the same config
    _methodChannel?.invokeMethod('play', _buildCreationParams());
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

      setState(() {
        _hasError = false;
        _errorMessage = null;
        _isBuffering = true;
      });

      // Send new play command to the existing native view
      _methodChannel?.invokeMethod('play', _buildCreationParams());
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
    // Show error state
    if (_hasError) {
      return _buildErrorWidget();
    }

    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Native ExoPlayer view
          AndroidView(
            viewType: 'com.goplay/native_player',
            creationParams: _buildCreationParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          ),

          // Buffering indicator
          if (_isBuffering)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),

          // Transparent tap-to-toggle overlay on top of video, but behind controls
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onTap,
              child: const SizedBox.shrink(),
            ),
          ),

          // Bottom controls overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !widget.showControls,
              child: AnimatedOpacity(
                opacity: widget.showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _buildControls(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final bottomPadding = widget.isFullscreen ? 14.0 : 4.0;
    final horizontalPadding = widget.isFullscreen ? 16.0 : 8.0;

    return Container(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 6,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withAlpha(180),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Play / Pause
          IconButton(
            onPressed: () {
              if (_isPlaying) {
                _methodChannel?.invokeMethod('pause');
              } else {
                _methodChannel?.invokeMethod('resume');
              }
            },
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            iconSize: 28,
          ),

          const SizedBox(width: 4),

          // LIVE badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, color: Colors.white, size: 6),
                SizedBox(width: 4),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // DRM indicator
          if (widget.channel.hasDrm) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(180),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.lock, color: Colors.white, size: 8),
                  SizedBox(width: 3),
                  Text(
                    'DRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Fullscreen toggle
          if (widget.onFullscreenToggle != null)
            IconButton(
              onPressed: widget.onFullscreenToggle,
              icon: Icon(
                widget.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.channel.hasDrm ? Icons.lock_outline : Icons.error_outline,
              color: widget.channel.hasDrm ? Colors.orange : Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              widget.channel.hasDrm ? 'DRM Protected Content' : 'Playback Error',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage ?? 'Unable to play this stream',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _retryPlayback,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
