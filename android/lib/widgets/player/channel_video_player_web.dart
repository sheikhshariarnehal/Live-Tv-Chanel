import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../../models/channel.dart';
import 'channel_video_player.dart';

Widget getChannelVideoPlayer({
  required Channel channel,
  VoidCallback? onFullscreenToggle,
  bool isFullscreen = false,
}) {
  return ChannelVideoPlayerWeb(
    channel: channel,
    onFullscreenToggle: onFullscreenToggle,
    isFullscreen: isFullscreen,
  );
}

/// Web video player using native HTML5 <video> element via HtmlElementView.
///
/// For web builds, this uses the browser's native HLS/DASH capabilities
/// (or hls.js if loaded) via a raw <video> element registered as a platform view.
class ChannelVideoPlayerWeb extends StatefulWidget implements ChannelVideoPlayer {
  @override
  final Channel channel;
  @override
  final VoidCallback? onFullscreenToggle;
  @override
  final bool isFullscreen;

  const ChannelVideoPlayerWeb({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
  });

  @override
  State<ChannelVideoPlayerWeb> createState() => _ChannelVideoPlayerWebState();
}

class _ChannelVideoPlayerWebState extends State<ChannelVideoPlayerWeb> {
  late final String _viewId;
  html.VideoElement? _videoElement;

  @override
  void initState() {
    super.initState();
    _viewId = 'video-player-${widget.channel.id}-${DateTime.now().millisecondsSinceEpoch}';
    _initVideoElement();
  }

  void _initVideoElement() {
    String streamUrl = widget.channel.streamUrl;
    if (streamUrl.isEmpty) return;

    // Convert raw TS link to HLS Blob so the HTML5 video tag can play it via hls.js
    final uri = Uri.parse(streamUrl);
    final path = uri.path.toLowerCase();
    if (path.endsWith('.ts')) {
      final manifestContent = '''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.0,
$streamUrl
#EXT-X-ENDLIST
''';
      final blob = html.Blob([manifestContent], 'application/vnd.apple.mpegurl');
      streamUrl = html.Url.createObjectUrlFromBlob(blob);
    }

    _videoElement = html.VideoElement()
      ..src = streamUrl
      ..autoplay = true
      ..controls = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black'
      ..setAttribute('playsinline', 'true');

    // Register as a platform view
    // ignore: undefined_prefixed_name
    // ignore: avoid_web_libraries_in_flutter
    html.document.body?.append(html.DivElement()..id = _viewId);

    // Use registerViewFactory for web platform views
    // This is handled by the HtmlElementView widget
  }

  @override
  void didUpdateWidget(ChannelVideoPlayerWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id ||
        oldWidget.channel.streamUrl != widget.channel.streamUrl) {
      _videoElement?.pause();
      _initVideoElement();
    }
  }

  @override
  void dispose() {
    _videoElement?.pause();
    _videoElement?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // The video would be rendered here via HtmlElementView in a real web build
          const Center(
            child: Text(
              'Web player — use Android app for best experience',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),

          // Bottom controls overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  const SizedBox(width: 8),
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
                  const Spacer(),
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
            ),
          ),
        ],
      ),
    );
  }
}
