import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/channel.dart';
import '../../services/local_proxy.dart';

class DrmPlayerController {
  VoidCallback? onPlay;
  VoidCallback? onPause;
  Function(Duration pos)? onSeek;

  void play() => onPlay?.call();
  void pause() => onPause?.call();
  void seek(Duration pos) => onSeek?.call(pos);
}

class DrmWebViewPlayer extends StatefulWidget {
  final Channel channel;
  final DrmPlayerController? controller;
  final Function(bool isPlaying) onPlayStateChanged;
  final Function(bool isBuffering) onBufferingStateChanged;
  final Function(Duration position, Duration duration) onProgressChanged;

  const DrmWebViewPlayer({
    super.key,
    required this.channel,
    this.controller,
    required this.onPlayStateChanged,
    required this.onBufferingStateChanged,
    required this.onProgressChanged,
  });

  @override
  State<DrmWebViewPlayer> createState() => _DrmWebViewPlayerState();
}

class _DrmWebViewPlayerState extends State<DrmWebViewPlayer> {
  InAppWebViewController? _webViewController;
  WebViewEnvironment? _webViewEnvironment;
  bool _isLoading = true;
  bool _envInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Set up controller callbacks to trigger HTML5 video actions
    if (widget.controller != null) {
      widget.controller!.onPlay = () {
        _webViewController?.evaluateJavascript(
          source: "document.getElementById('video').play();",
        );
      };
      widget.controller!.onPause = () {
        _webViewController?.evaluateJavascript(
          source: "document.getElementById('video').pause();",
        );
      };
      widget.controller!.onSeek = (pos) {
        final sec = pos.inMilliseconds / 1000.0;
        _webViewController?.evaluateJavascript(
          source: "document.getElementById('video').currentTime = $sec;",
        );
      };
    }

    _initEnvironment();
  }

  Future<void> _initEnvironment() async {
    if (!kIsWeb && Platform.isWindows) {
      try {
        final availableVersion = await WebViewEnvironment.getAvailableVersion();
        if (availableVersion != null) {
          final appDataDir = await getApplicationSupportDirectory();
          final env = await WebViewEnvironment.create(
            settings: WebViewEnvironmentSettings(
              userDataFolder: '${appDataDir.path}\\EBWebView',
              additionalBrowserArguments: '--disable-web-security',
            ),
          );
          if (mounted) {
            setState(() {
              _webViewEnvironment = env;
              _envInitialized = true;
            });
          }
          return;
        }
      } catch (e) {
        debugPrint("DrmWebViewPlayer: Error initializing WebViewEnvironment: $e");
      }
    }
    if (mounted) {
      setState(() {
        _envInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isWindows && !_envInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.cyanAccent,
        ),
      );
    }

    // Construct stream URL
    var playUrl = widget.channel.streamUrl;
    if (widget.channel.proxy) {
      playUrl = LocalProxy.getUrl(playUrl, widget.channel.headers);
    }

    // Construct headers JSON
    final headers = widget.channel.headers.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    // Include Referer and User-Agent if Toffee CDN is used
    if (playUrl.contains('otte.cache.aiv-cdn.net')) {
      if (!headers.containsKey('Referer')) {
        headers['Referer'] = 'https://kkx4.livekhelatv.com/';
      }
      if (!headers.containsKey('User-Agent')) {
        headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
      }
    }
    final headersJson = jsonEncode(headers);

    // Construct DRM config JSON
    Map<String, dynamic>? drmConfig;
    if (widget.channel.hasDrm) {
      final drm = widget.channel.drm!;
      drmConfig = {
        'type': drm.type.name,
      };

      if (drm.isClearKey) {
        if (drm.clearKeys != null) {
          drmConfig['clearKeys'] = drm.clearKeys;
        } else if (drm.kid != null && drm.key != null) {
          drmConfig['kid'] = drm.kid;
          drmConfig['key'] = drm.key;
        }
      } else if (drm.isWidevine) {
        if (drm.licenseUrl != null) {
          drmConfig['licenseUrl'] = drm.licenseUrl;
        }
        if (drm.licenseHeaders != null) {
          drmConfig['licenseHeaders'] = drm.licenseHeaders;
        }
      }
    }
    
    // We escape the JSON single quotes for JavaScript injection compatibility
    final drmConfigStr = drmConfig != null ? jsonEncode(drmConfig).replaceAll("'", "\\'") : 'null';
    final headersStr = jsonEncode(headers).replaceAll("'", "\\'");

    return Stack(
      children: [
        InAppWebView(
          initialFile: "assets/drm_player.html",
          webViewEnvironment: _webViewEnvironment,
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            useWideViewPort: true,
            javaScriptEnabled: true,
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            
            // Register JavaScript handlers to communicate playback state to Flutter
            controller.addJavaScriptHandler(
              handlerName: 'onPlayStateChanged',
              callback: (args) {
                final isPlaying = args[0] as bool;
                widget.onPlayStateChanged(isPlaying);
              },
            );

            controller.addJavaScriptHandler(
              handlerName: 'onBufferingStateChanged',
              callback: (args) {
                final isBuffering = args[0] as bool;
                widget.onBufferingStateChanged(isBuffering);
              },
            );

            controller.addJavaScriptHandler(
              handlerName: 'onProgressChanged',
              callback: (args) {
                final posSec = (args[0] as num).toDouble();
                final durSec = (args[1] as num).toDouble();
                widget.onProgressChanged(
                  Duration(milliseconds: (posSec * 1000).toInt()),
                  Duration(milliseconds: (durSec * 1000).toInt()),
                );
              },
            );
          },
          onLoadStop: (controller, url) async {
            setState(() {
              _isLoading = false;
            });
            // Inject player initialization script
            final jsStr = "initPlayer('$playUrl', '$drmConfigStr', '$headersStr')";
            debugPrint("DrmWebViewPlayer: Injecting JS: $jsStr");
            await controller.evaluateJavascript(source: jsStr);
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint("DRM Player WebView Console: ${consoleMessage.message}");
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.cyanAccent,
            ),
          ),
      ],
    );
  }
}
