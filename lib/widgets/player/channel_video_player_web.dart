import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/src/player/web/utils/hls.dart';
import 'package:media_kit_video/media_kit_video.dart';
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
  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    // Force media_kit to load hls.js from CDN to avoid local assets 404 error
    try {
      HLS.ensureInitialized(hls: 'https://cdn.jsdelivr.net/npm/hls.js@1.4.10/dist/hls.min.js');
    } catch (e) {
      // Ignore
    }
    _player = Player();
    _controller = VideoController(_player);
    _initPlayer();
  }

  void _initPlayer() async {
    String streamUrl = widget.channel.streamUrl;
    if (streamUrl.isEmpty) return;

    // Convert raw TS link to HLS Blob so standard HTML5 video tag can demux it via MSE if hls.js is loaded
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

    await _player.open(
      Media(
        streamUrl,
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: MaterialVideoControlsTheme(
          normal: MaterialVideoControlsThemeData(
            displaySeekBar: false,
            seekGesture: false,
            seekOnDoubleTap: false,
            topButtonBar: const [],
            primaryButtonBar: const [],
            bottomButtonBar: [
              const MaterialPlayOrPauseButton(),
              const MaterialDesktopVolumeButton(),
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
                    Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
          fullscreen: MaterialVideoControlsThemeData(
            displaySeekBar: false,
            seekGesture: false,
            seekOnDoubleTap: false,
            topButtonBar: const [],
            primaryButtonBar: const [],
            bottomButtonBar: [
              const MaterialPlayOrPauseButton(),
              const MaterialDesktopVolumeButton(),
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
                    Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
          child: Video(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
