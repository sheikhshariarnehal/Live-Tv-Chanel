import 'package:flutter/material.dart';
import '../../models/channel.dart';

Widget getChannelVideoPlayer({required Channel channel}) {
  return const Center(
    child: Text(
      'Player is not supported on this platform',
      style: TextStyle(color: Colors.white),
    ),
  );
}
