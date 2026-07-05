import 'package:flutter/material.dart';
import '../../models/channel.dart';
import 'channel_video_player_stub.dart'
    if (dart.library.html) 'channel_video_player_web.dart';

abstract class ChannelVideoPlayer extends StatefulWidget {
  final Channel channel;
  final VoidCallback? onFullscreenToggle;
  final bool isFullscreen;
  final bool showControls;
  final VoidCallback? onTap;
  final VoidCallback? onPreviousChannel;
  final VoidCallback? onNextChannel;
  final VoidCallback? onInteract;

  const ChannelVideoPlayer({
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

  static Widget create({
    required Channel channel,
    VoidCallback? onFullscreenToggle,
    bool isFullscreen = false,
    bool showControls = true,
    VoidCallback? onTap,
    VoidCallback? onPreviousChannel,
    VoidCallback? onNextChannel,
    VoidCallback? onInteract,
  }) {
    return getChannelVideoPlayer(
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
}
