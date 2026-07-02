import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../../models/channel.dart';
import '../../models/drm_config.dart';
import '../../services/drm_service.dart';
import '../../services/local_proxy.dart';
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
  bool _drmError = false;
  String? _drmErrorMessage;

  @override
  void initState() {
    super.initState();
    _player = Player();
    
    // Subscribe to internal media_kit / mpv logs for debugging playback & decryption
    _player.stream.log.listen((event) {
      debugPrint('media_kit: [${event.level}] ${event.prefix}: ${event.text}');
    });

    _controller = VideoController(_player);
    _initPlayer();
  }

  void _initPlayer() async {
    if (widget.channel.streamUrl.isEmpty) return;

    if (widget.channel.hasDrm) {
      await _initDrmPlayer();
    } else {
      await _initDirectPlayer();
    }
  }

  /// Standard non-DRM playback
  Future<void> _initDirectPlayer() async {
    final streamUrl = widget.channel.proxy
        ? LocalProxy.getUrl(widget.channel.streamUrl, widget.channel.headers)
        : widget.channel.streamUrl;

    await _player.open(
      Media(
        streamUrl,
        httpHeaders: widget.channel.headers.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ),
    );
  }

  /// DRM-protected playback
  Future<void> _initDrmPlayer() async {
    final drm = widget.channel.drm!;

    switch (drm.type) {
      case DrmType.clearkey:
        await _initClearKeyPlayer(drm);
        break;
      case DrmType.widevine:
        await _initWidevinePlayer(drm);
        break;
      case DrmType.playready:
        setState(() {
          _drmError = true;
          _drmErrorMessage = 'PlayReady DRM is not yet supported';
        });
        break;
    }
  }

  /// ClearKey DRM playback using platform channel
  Future<void> _initClearKeyPlayer(DrmConfig drm) async {
    try {
      if (drm.kid == null || drm.key == null) {
        setState(() {
          _drmError = true;
          _drmErrorMessage = 'ClearKey DRM requires kid and key';
        });
        return;
      }

      // Build ClearKey license response
      final licenseJson = await DrmService.buildClearKeyLicense(
        kid: drm.kid!,
        key: drm.key!,
      );

      // For media_kit on Android, ClearKey DASH streams (.mpd with CENC)
      // need to be opened with the DRM configuration passed through
      // the platform-specific configuration.
      //
      // media_kit uses mpv/libmpv under the hood which handles ClearKey
      // via the --demuxer-lavf-o option for DASH streams.
      //
      // We pass ClearKey credentials as mpv options.
      final kidB64 = DrmService.hexToBase64Url(drm.kid!);
      final keyB64 = DrmService.hexToBase64Url(drm.key!);

      final streamUrl = widget.channel.proxy
          ? LocalProxy.getUrl(widget.channel.streamUrl, widget.channel.headers)
          : widget.channel.streamUrl;

      // Configure mpv for ClearKey DASH decryption BEFORE loading the media
      // mpv supports ClearKey via --demuxer-lavf-o=decryption_key=<key>
      if (_player.platform is NativePlayer) {
        await (_player.platform as NativePlayer).setProperty(
          'demuxer-lavf-o',
          'decryption_key=${drm.key}',
        );
      }

      await _player.open(
        Media(
          streamUrl,
          httpHeaders: widget.channel.headers.map(
            (key, value) => MapEntry(key, value.toString()),
          ),
          extras: {
            'drm_type': 'clearkey',
            'drm_kid': drm.kid!,
            'drm_key': drm.key!,
            'drm_license': licenseJson,
          },
        ),
      );
    } catch (e) {
      setState(() {
        _drmError = true;
        _drmErrorMessage = 'Failed to configure ClearKey DRM: $e';
      });
    }
  }

  /// Widevine DRM playback (future — requires ExoPlayer native integration)
  Future<void> _initWidevinePlayer(DrmConfig drm) async {
    try {
      if (drm.licenseUrl == null) {
        setState(() {
          _drmError = true;
          _drmErrorMessage = 'Widevine DRM requires a license URL';
        });
        return;
      }

      final streamUrl = widget.channel.proxy
          ? LocalProxy.getUrl(widget.channel.streamUrl, widget.channel.headers)
          : widget.channel.streamUrl;

      // For Widevine, media_kit/mpv does not natively support it.
      // We need to use the native ExoPlayer through a platform channel.
      // For now, attempt playback and report if DRM blocks it.
      await _player.open(
        Media(
          streamUrl,
          httpHeaders: {
            ...widget.channel.headers.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
            if (drm.licenseHeaders != null) ...drm.licenseHeaders!,
          },
          extras: {
            'drm_type': 'widevine',
            'drm_license_url': drm.licenseUrl!,
          },
        ),
      );
    } catch (e) {
      setState(() {
        _drmError = true;
        _drmErrorMessage = 'Failed to configure Widevine DRM: $e';
      });
    }
  }

  @override
  void didUpdateWidget(ChannelVideoPlayerNative oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id ||
        oldWidget.channel.streamUrl != widget.channel.streamUrl) {
      setState(() {
        _drmError = false;
        _drmErrorMessage = null;
      });
      _initPlayer();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show DRM error state
    if (_drmError) {
      return Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                'DRM Protected Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _drmErrorMessage ?? 'Unable to play DRM-protected stream',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _drmError = false;
                    _drmErrorMessage = null;
                  });
                  _initPlayer();
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
              // DRM indicator in player controls
              if (widget.channel.hasDrm) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(180),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock, color: Colors.white, size: 8),
                      SizedBox(width: 3),
                      Text('DRM', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
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
              if (widget.channel.hasDrm) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(180),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock, color: Colors.white, size: 8),
                      SizedBox(width: 3),
                      Text('DRM', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
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
