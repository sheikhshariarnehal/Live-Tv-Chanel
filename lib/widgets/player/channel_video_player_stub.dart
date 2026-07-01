import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../models/channel.dart';
import 'channel_video_player.dart';

Widget getChannelVideoPlayer({
  required Channel channel,
  VoidCallback? onFullscreenToggle,
  bool isFullscreen = false,
}) {
  return ChannelVideoPlayerNative(
    channel: channel,
    onFullscreenToggle: onFullscreenToggle,
    isFullscreen: isFullscreen,
  );
}

class ChannelVideoPlayerNative extends StatefulWidget implements ChannelVideoPlayer {
  @override
  final Channel channel;
  @override
  final VoidCallback? onFullscreenToggle;
  @override
  final bool isFullscreen;

  const ChannelVideoPlayerNative({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
  });

  @override
  State<ChannelVideoPlayerNative> createState() => _ChannelVideoPlayerNativeState();
}

class _ChannelVideoPlayerNativeState extends State<ChannelVideoPlayerNative> {
  late final Player _player;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(_player);
    _initPlayer();
  }

  void _initPlayer() async {
    if (widget.channel.streamUrl.isEmpty) return;
    await _player.open(
      Media(
        widget.channel.streamUrl,
        httpHeaders: widget.channel.headers?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
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
