import 'package:flutter/material.dart';
import '../../models/channel.dart';
import 'channel_video_player_stub.dart'
    if (dart.library.html) 'channel_video_player_web.dart';

abstract class ChannelVideoPlayer extends StatefulWidget {
  final Channel channel;

  const ChannelVideoPlayer({super.key, required this.channel});

  static Widget create({required Channel channel}) {
    return getChannelVideoPlayer(channel: channel);
  }
}
