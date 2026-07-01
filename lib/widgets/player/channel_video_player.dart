import 'package:flutter/material.dart';
import '../../models/channel.dart';
import 'channel_video_player_stub.dart'
    if (dart.library.html) 'channel_video_player_web.dart';

abstract class ChannelVideoPlayer extends StatefulWidget {
  final Channel channel;
  final VoidCallback? onFullscreenToggle;
  final bool isFullscreen;

  const ChannelVideoPlayer({
    super.key,
    required this.channel,
    this.onFullscreenToggle,
    this.isFullscreen = false,
  });

  static Widget create({
    required Channel channel,
    VoidCallback? onFullscreenToggle,
    bool isFullscreen = false,
  }) {
    return getChannelVideoPlayer(
      channel: channel,
      onFullscreenToggle: onFullscreenToggle,
      isFullscreen: isFullscreen,
    );
  }
}
