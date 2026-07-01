import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import '../../models/channel.dart';
import 'channel_video_player.dart';

Widget getChannelVideoPlayer({required Channel channel}) {
  return ChannelVideoPlayerWeb(channel: channel);
}

class ChannelVideoPlayerWeb extends StatefulWidget implements ChannelVideoPlayer {
  @override
  final Channel channel;

  const ChannelVideoPlayerWeb({super.key, required this.channel});

  @override
  State<ChannelVideoPlayerWeb> createState() => _ChannelVideoPlayerWebState();
}

class _ChannelVideoPlayerWebState extends State<ChannelVideoPlayerWeb> {
  late html.VideoElement _videoElement;
  dynamic _hls;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    // Unique view type to avoid registration collisions when switching channels
    _viewType = 'video-player-${widget.channel.id}-${DateTime.now().millisecondsSinceEpoch}';
    
    _videoElement = html.VideoElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.backgroundColor = 'black'
      ..autoplay = true
      ..controls = true
      ..setAttribute('playsinline', 'true');

    // Register view factory
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => _videoElement);

    // Initialize player source loading
    _initPlayer();
  }

  void _initPlayer() {
    String streamUrl = widget.channel.streamUrl;
    if (streamUrl.isEmpty) return;

    // Convert raw TS link to HLS Blob so hls.js can play it
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

    final hasHls = js.context.hasProperty('Hls');
    if (hasHls) {
      final hlsClass = js.context['Hls'] as js.JsFunction;
      final config = js.JsObject.jsify({
        'maxMaxBufferLength': 10,
        'xhrSetup': js.JsFunction.withThis((js.JsObject thisArg, js.JsObject xhr, String url) {
          if (widget.channel.headers != null) {
            widget.channel.headers!.forEach((key, value) {
              xhr.callMethod('setRequestHeader', [key, value]);
            });
          }
        }),
      });

      final hlsInstance = js.JsObject(hlsClass, [config]);
      _hls = hlsInstance;

      hlsInstance.callMethod('loadSource', [streamUrl]);
      hlsInstance.callMethod('attachMedia', [_videoElement]);
    } else if (_videoElement.canPlayType('application/vnd.apple.mpegurl').isNotEmpty) {
      _videoElement.src = streamUrl;
    }
  }

  @override
  void dispose() {
    if (_hls != null) {
      try {
        (_hls as js.JsObject).callMethod('destroy');
      } catch (e) {
        // Silent catch
      }
    }
    _videoElement.src = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
