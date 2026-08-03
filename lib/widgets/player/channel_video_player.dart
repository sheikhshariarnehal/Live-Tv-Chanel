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
  /// TV-only: called when D-Pad Right is pressed to shift focus to the
  /// channel-list side panel. Null on non-TV layouts.
  final VoidCallback? onFocusChannelPanel;
  final bool isTvDevice;
  final FocusNode? playPauseFocusNode;

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
    this.onFocusChannelPanel,
    this.isTvDevice = false,
    this.playPauseFocusNode,
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
    VoidCallback? onFocusChannelPanel,
    bool isTvDevice = false,
    FocusNode? playPauseFocusNode,
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
      onFocusChannelPanel: onFocusChannelPanel,
      isTvDevice: isTvDevice,
      playPauseFocusNode: playPauseFocusNode,
    );
  }
}
