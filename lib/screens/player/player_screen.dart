import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../widgets/player/channel_video_player.dart';

// ─── Pre-cached top-level constants — zero per-frame allocations ─

const _kScreenBg = BoxDecoration(
  color: GoPlayTheme.surface,
);

const _kInfoCardDeco = BoxDecoration(
  color: GoPlayTheme.surfaceContainer,
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

const _kSidePanelDeco = BoxDecoration(
  color: GoPlayTheme.surfaceContainerLow,
  border: Border(left: BorderSide(color: GoPlayTheme.cardBorder, width: 0.8)),
);

// Top-bar gradient pre-cached — avoids allocation on every fullscreen build
const _kTopBarGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xDC000000), Color(0x78000000), Colors.transparent],
  ),
);

// Tile decorations — current / hovered / normal
const _kTileDecoActive = BoxDecoration(
  color: GoPlayTheme.surfaceContainerHigh,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.primary, width: 1.0),
  ),
  boxShadow: [
    BoxShadow(color: Color(0x1F00E676), blurRadius: 8, offset: Offset(0, 2)),
  ],
);
// Tile decorations — hovered / normal
const _kTileDecoHovered = BoxDecoration(
  color: GoPlayTheme.surfaceContainerHigh,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);
const _kTileDecoNormal = BoxDecoration(
  color: GoPlayTheme.surfaceContainer,
  borderRadius: BorderRadius.all(Radius.circular(16)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

// Back-button decoration
const _kBackBtnDeco = BoxDecoration(
  color: Color(0x78000000),
  shape: BoxShape.circle,
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x2BFFFFFF), width: 0.8),
  ),
);

// Playing tag
const _kPlayingTagDeco = BoxDecoration(
  color: Color(0x1A00E676),
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: Color(0x3200E676), width: 0.5)),
);
const _kPlayingTagStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 8,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.4,
);

// Server chip decorations
const _kChipDecoActive = BoxDecoration(
  color: Color(0x1F2196F3),
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0xFF2196F3), width: 1.2),
  ),
);
const _kChipDecoInactive = BoxDecoration(
  color: Colors.transparent,
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: Colors.white30, width: 1.0),
  ),
);

// Avatar decoration
const _kAvatarDeco = BoxDecoration(
  color: Color(0x14FFFFFF),
  shape: BoxShape.circle,
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x1AFFFFFF), width: 1.0),
  ),
);

// Pill decorations (pre-cached for each variant)
const _kPillDecoHd = BoxDecoration(
  color: Color(0x1E3B82F6),
  borderRadius: BorderRadius.all(Radius.circular(6)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x323B82F6), width: 0.5),
  ),
);
const _kPillDecoSd = BoxDecoration(
  color: Color(0x1E00E676),
  borderRadius: BorderRadius.all(Radius.circular(6)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x3200E676), width: 0.5),
  ),
);
const _kPillDecoNeutral = BoxDecoration(
  color: Color(0x0CFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(6)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x10FFFFFF), width: 0.5),
  ),
);
const _kPillDecoDrm = BoxDecoration(
  color: Color(0x1EFF9800),
  borderRadius: BorderRadius.all(Radius.circular(6)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x32FF9800), width: 0.5),
  ),
);

// Text styles (pre-cached Google Fonts — allocated once at startup)
final _kTitleStyle = GoogleFonts.outfit(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
final _kSectionLabelStyle = GoogleFonts.outfit(
  color: Colors.white60,
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
);

final _kTileNameActiveStyle = GoogleFonts.outfit(
  color: GoPlayTheme.primary,
  fontSize: 13.5,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
final _kTileNameNormalStyle = GoogleFonts.outfit(
  color: Colors.white,
  fontSize: 13.5,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

const _kPillStyleHd = TextStyle(
  color: Color(0xFF60A5FA),
  fontSize: 9,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);
const _kPillStyleSd = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 9,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);
const _kPillStyleNeutral = TextStyle(
  color: Colors.white60,
  fontSize: 9,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);
const _kPillStyleDrm = TextStyle(
  color: Color(0xFFFFB74D),
  fontSize: 9,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);
const _kTileMetaActiveStyle = TextStyle(color: Color(0xCC00E676), fontSize: 10.5);
const _kTileMetaNormalStyle = TextStyle(color: Colors.white38, fontSize: 10.5);
const _kChipActiveStyle = TextStyle(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.w600,
);
const _kChipInactiveStyle = TextStyle(
  color: Colors.white70,
  fontSize: 11,
  fontWeight: FontWeight.w500,
);

// Cached identity matrix — never reallocated
final _kIdentityMatrix = Matrix4.identity();
final _kHoverMatrix = Matrix4.translationValues(0.0, -1.0, 0.0);

class PlayerScreen extends ConsumerStatefulWidget {
  final String channelId;
  final List<String>? eventChannels;
  final bool forceFullscreen;

  const PlayerScreen({
    super.key,
    required this.channelId,
    this.eventChannels,
    this.forceFullscreen = false,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late String _currentChannelId;
  bool _controlsVisible = true;
  Timer? _controlsTimer;
  String? _lastHistoryChannelId;
  static const _pipChannel = MethodChannel('com.goplay/pip');

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _startControlsTimer();

    // Keep screen awake while player is active
    WakelockPlus.enable();

    if (widget.forceFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }

    _pipChannel.invokeMethod('setPlayerActive', true);
    _pipChannel.setMethodCallHandler((call) async {
      if (call.method == 'onPiPModeChanged') {
        final isInPiP = call.arguments as bool? ?? false;
        if (isInPiP) {
          setState(() {
            _controlsVisible = false;
          });
        }
      }
    });
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  void _onPlayerTap() {
    final next = !_controlsVisible;
    setState(() => _controlsVisible = next);
    if (next) {
      _startControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void _onPlayerInteract() {
    if (_controlsVisible) {
      _startControlsTimer();
    }
  }

  void _toggleFullscreen() {
    final isFullscreen =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (!isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        }
      });
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      });
    }
    setState(() => _controlsVisible = true);
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _pipChannel.invokeMethod('setPlayerActive', false);
    _pipChannel.setMethodCallHandler(null);
    // Allow screen to sleep again when leaving the player
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _addToHistory(Channel channel) {
    if (_lastHistoryChannelId != channel.id) {
      _lastHistoryChannelId = channel.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(watchHistoryProvider.notifier).addChannel(channel);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);
    final mq = MediaQuery.of(context);
    final isDesktop = mq.size.width >= 800;
    final isFullscreen = mq.orientation == Orientation.landscape;

    return PopScope(
      canPop: !isFullscreen || widget.forceFullscreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.forceFullscreen) {
          Navigator.of(context).pop();
        } else {
          _toggleFullscreen();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF070709),
        body: DecoratedBox(
          decoration: _kScreenBg,
          child: channelsAsync.when(
            data: (channels) {
              final channel = channels.cast<Channel?>().firstWhere(
                (c) => c?.id == _currentChannelId,
                orElse: () => null,
              );

              if (channel == null) {
                return const Center(
                  child: Text(
                    'Channel not found',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              _addToHistory(channel);

              // Find related channels to enable prev/next buttons
              final relatedChannels = widget.eventChannels != null
                  ? channels.where((c) => widget.eventChannels!.contains(c.id)).toList()
                  : channels.where((c) => c.category == channel.category).toList();

              final currentIndex = relatedChannels.indexWhere((c) => c.id == channel.id);
              final prevChannel = (currentIndex > 0) ? relatedChannels[currentIndex - 1] : null;
              final nextChannel = (currentIndex != -1 && currentIndex < relatedChannels.length - 1)
                  ? relatedChannels[currentIndex + 1]
                  : null;

              final onPrev = prevChannel != null ? () {
                setState(() {
                  _currentChannelId = prevChannel.id;
                });
                _startControlsTimer();
              } : null;

              final onNext = nextChannel != null ? () {
                setState(() {
                  _currentChannelId = nextChannel.id;
                });
                _startControlsTimer();
              } : null;

              // DESKTOP LAYOUT
              if (isDesktop && !isFullscreen) {
                return Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: _PlayerContainer(
                        channel: channel,
                        isFullscreen: false,
                        controlsVisible: _controlsVisible,
                        onTap: _onPlayerTap,
                        onFullscreenToggle: _toggleFullscreen,
                        showBackButton: true,
                        onPreviousChannel: onPrev,
                        onNextChannel: onNext,
                        onInteract: _onPlayerInteract,
                      ),
                    ),
                    const VerticalDivider(
                      width: 0.8,
                      thickness: 0.8,
                      color: Color(0x14FFFFFF),
                    ),
                    SizedBox(
                      width: 360,
                      child: DecoratedBox(
                        decoration: _kSidePanelDeco,
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ChannelInfoBar(channel: channel),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(
                                  color: Color(0x0FFFFFFF),
                                  height: 1,
                                ),
                              ),
                              const _SectionLabel(text: 'SWITCH CHANNEL'),
                              Expanded(
                                child: _RelatedChannelsList(
                                  category: channel.category ?? '',
                                  currentChannelId: channel.id,
                                  isScrollable: true,
                                  onChannelSelected: (id) =>
                                      setState(() => _currentChannelId = id),
                                  eventChannels: widget.eventChannels,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // MOBILE / FULLSCREEN LAYOUT
              return Stack(
                children: [
                  // 1. Details & scrollable channels list (placed at the bottom)
                  // We only display and layout this if not in fullscreen mode.
                  // We use Offstage with maintainState: true to keep it alive
                  // and avoid destroying/recreating the list during transitions.
                  Positioned.fill(
                    child: Offstage(
                      offstage: isFullscreen,
                      child: Column(
                        children: [
                          const SizedBox(height: 240), // Placeholder for the player
                          Expanded(
                            child: SafeArea(
                              top: false,
                              bottom: true,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  _ChannelInfoBar(channel: channel),
                                  const _SectionLabel(text: 'SWITCH CHANNEL'),
                                  _RelatedChannelsList(
                                    category: channel.category ?? '',
                                    currentChannelId: channel.id,
                                    isScrollable: false,
                                    onChannelSelected: (id) =>
                                        setState(() => _currentChannelId = id),
                                    eventChannels: widget.eventChannels,
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Video Player Container (placed on top)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: isFullscreen ? mq.size.height : 240,
                    child: SafeArea(
                      top: !isFullscreen,
                      bottom: false,
                      left: false,
                      right: false,
                      child: _PlayerContainer(
                        channel: channel,
                        isFullscreen: isFullscreen,
                        controlsVisible: _controlsVisible,
                        onTap: _onPlayerTap,
                        onFullscreenToggle: _toggleFullscreen,
                        showBackButton: !isFullscreen,
                        onPreviousChannel: onPrev,
                        onNextChannel: onNext,
                        onInteract: _onPlayerInteract,
                        topBar: isFullscreen
                            ? _FullscreenTopBar(
                                category: channel.category ?? '',
                                currentChannelId: channel.id,
                                onBackPressed: widget.forceFullscreen
                                    ? () => Navigator.of(context).pop()
                                    : _toggleFullscreen,
                                onChannelSelected: (id) {
                                  setState(() => _currentChannelId = id);
                                  _startControlsTimer();
                                },
                                eventChannels: widget.eventChannels,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: GoPlayTheme.primary,
                strokeWidth: 2,
              ),
            ),
            error: (e, s) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: GoPlayTheme.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Player Container (isolated repaints) ───────────────────────

class _PlayerContainer extends StatelessWidget {
  final Channel channel;
  final bool isFullscreen;
  final bool controlsVisible;
  final VoidCallback onTap;
  final VoidCallback onFullscreenToggle;
  final bool showBackButton;
  final Widget? topBar;
  final VoidCallback? onPreviousChannel;
  final VoidCallback? onNextChannel;
  final VoidCallback? onInteract;

  const _PlayerContainer({
    required this.channel,
    required this.isFullscreen,
    required this.controlsVisible,
    required this.onTap,
    required this.onFullscreenToggle,
    this.showBackButton = false,
    this.topBar,
    this.onPreviousChannel,
    this.onNextChannel,
    this.onInteract,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isFullscreen ? double.infinity : 240,
      width: double.infinity,
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [
            // Video — isolated from overlay repaints
            RepaintBoundary(
              child: ChannelVideoPlayer.create(
                channel: channel,
                isFullscreen: isFullscreen,
                onFullscreenToggle: onFullscreenToggle,
                showControls: controlsVisible,
                onTap: onTap,
                onPreviousChannel: onPreviousChannel,
                onNextChannel: onNextChannel,
                onInteract: onInteract,
              ),
            ),

            // Back button
            if (showBackButton)
              Positioned(
                top: 16,
                left: 16,
                child: IgnorePointer(
                  ignoring: !controlsVisible,
                  child: AnimatedOpacity(
                    opacity: controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const _BackButton(),
                  ),
                ),
              ),

            // Fullscreen top bar
            if (topBar != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: !controlsVisible,
                  child: AnimatedOpacity(
                    opacity: controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: topBar!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Back Button (premium glass design) ─────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 34,
        height: 34,
        child: DecoratedBox(
          decoration: _kBackBtnDeco,
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ─── Channel Info Bar (premium glass card) ──────────────────────

class _ChannelInfoBar extends StatelessWidget {
  final Channel channel;
  const _ChannelInfoBar({required this.channel});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _kInfoCardDeco,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Row(
          children: [
            _ChannelAvatar(name: channel.name, logo: channel.logo, size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    channel.name,
                    style: _kTitleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _MetadataRow(channel: channel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Metadata pills row ─────────────────────────────────────────

class _MetadataRow extends StatelessWidget {
  final Channel channel;
  const _MetadataRow({required this.channel});

  @override
  Widget build(BuildContext context) {
    final categoryName = channel.category?.toUpperCase() ?? '';

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        if (channel.quality != null)
          DecoratedBox(
            decoration: channel.quality == '4K' ? _kPillDecoHd : _kPillDecoSd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              child: Text(
                channel.quality!,
                style: channel.quality == '4K' ? _kPillStyleHd : _kPillStyleSd,
              ),
            ),
          ),
        if (categoryName.isNotEmpty)
          DecoratedBox(
            decoration: _kPillDecoNeutral,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              child: Text(categoryName, style: _kPillStyleNeutral),
            ),
          ),
        if (channel.country != null && channel.country!.isNotEmpty)
          DecoratedBox(
            decoration: _kPillDecoNeutral,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              child: Text(channel.country!, style: _kPillStyleNeutral),
            ),
          ),
        if (channel.hasDrm)
          DecoratedBox(
            decoration: _kPillDecoDrm,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
              child: Text('DRM', style: _kPillStyleDrm),
            ),
          ),
      ],
    );
  }
}

// ─── Section Label ──────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(text, style: _kSectionLabelStyle),
    );
  }
}

// ─── Channel Avatar (lightweight) ───────────────────────────────

class _ChannelAvatar extends StatelessWidget {
  final String name;
  final String? logo;
  final double size;
  const _ChannelAvatar({required this.name, this.logo, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: _kAvatarDeco,
        child: ClipOval(
          child: logo != null && logo!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: logo!,
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  memCacheWidth: (size * 2).toInt(),
                  memCacheHeight: (size * 2).toInt(),
                  fadeInDuration: const Duration(milliseconds: 150),
                  placeholder: (context, url) => Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size * 0.28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, err) => Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size * 0.28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Related Channels List ──────────────────────────────────────

class _RelatedChannelsList extends ConsumerWidget {
  final String category;
  final String currentChannelId;
  final bool isScrollable;
  final Function(String) onChannelSelected;
  final List<String>? eventChannels;

  const _RelatedChannelsList({
    required this.category,
    required this.currentChannelId,
    required this.isScrollable,
    required this.onChannelSelected,
    this.eventChannels,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return channelsAsync.when(
      data: (channels) {
        final List<Channel> related;
        if (eventChannels != null) {
          related = channels
              .where((c) => eventChannels!.contains(c.id))
              .toList();
        } else {
          related = channels.where((c) => c.category == category).toList();
        }

        if (related.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No other channels in this category',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          );
        }

        if (isScrollable) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: related.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final ch = related[index];
              final isCurrent = ch.id == currentChannelId;
              return _ChannelTile(
                channel: ch,
                isCurrent: isCurrent,
                onTap: () => onChannelSelected(ch.id),
              );
            },
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final ch in related)
              _ChannelTile(
                channel: ch,
                isCurrent: ch.id == currentChannelId,
                onTap: () => onChannelSelected(ch.id),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            color: GoPlayTheme.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

// ─── Channel Tile (interactive hover & stateful animation) ──────

class _ChannelTile extends StatefulWidget {
  final Channel channel;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ChannelTile({
    required this.channel,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  State<_ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<_ChannelTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    final isCurrent = widget.isCurrent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: isCurrent ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isCurrent ? null : widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            transform: _isHovered && !isCurrent
                ? _kHoverMatrix
                : _kIdentityMatrix,
            decoration: isCurrent
                ? _kTileDecoActive
                : (_isHovered ? _kTileDecoHovered : _kTileDecoNormal),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  _ChannelAvatar(
                    name: channel.name,
                    logo: channel.logo,
                    size: 38,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                channel.name,
                                style: isCurrent
                                    ? _kTileNameActiveStyle
                                    : _kTileNameNormalStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              const _EqualizerBars(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          [
                            channel.quality,
                            channel.category,
                            channel.country,
                          ].where((s) => s != null && s.isNotEmpty).join(' · '),
                          style: isCurrent
                              ? _kTileMetaActiveStyle
                              : _kTileMetaNormalStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isCurrent)
                    _buildPlayingTag()
                  else if (channel.isLive)
                    const _LiveDot(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayingTag() {
    return const DecoratedBox(
      decoration: _kPlayingTagDeco,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text('PLAYING', style: _kPlayingTagStyle),
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 6,
      height: 6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GoPlayTheme.liveBadge,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─── Equalizer Bars (CustomPainter — zero widget rebuilds) ──────

class _EqualizerBars extends StatefulWidget {
  const _EqualizerBars();
  @override
  State<_EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<_EqualizerBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: const Size(11, 10),
        painter: _EqualizerPainter(_ctrl),
      ),
    );
  }
}

class _EqualizerPainter extends CustomPainter {
  final Animation<double> animation;
  _EqualizerPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = GoPlayTheme.primary;
    const barW = 2.5;
    const gap = (11.0 - 3 * barW) / 2;

    for (int i = 0; i < 3; i++) {
      final phase = i * (2 / 3 * math.pi);
      final h =
          2 +
          8 *
              (0.5 + 0.5 * math.sin(animation.value * 2 * math.pi + phase))
                  .abs();
      final x = i * (barW + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, barW, h),
          const Radius.circular(1.5),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_EqualizerPainter old) => false;
}

// ─── Fullscreen Top Bar ─────────────────────────────────────────

class _FullscreenTopBar extends ConsumerWidget {
  final String category;
  final String currentChannelId;
  final VoidCallback onBackPressed;
  final Function(String) onChannelSelected;
  final List<String>? eventChannels;

  const _FullscreenTopBar({
    required this.category,
    required this.currentChannelId,
    required this.onBackPressed,
    required this.onChannelSelected,
    this.eventChannels,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return DecoratedBox(
      decoration: _kTopBarGradient,
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: true,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              GestureDetector(
                onTap: onBackPressed,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: channelsAsync.when(
                  data: (channels) {
                    final List<Channel> related;
                    if (eventChannels != null) {
                      related = channels
                          .where((c) => eventChannels!.contains(c.id))
                          .toList();
                    } else {
                      related = channels
                          .where((c) => c.category == category)
                          .toList();
                    }
                    if (related.isEmpty) return const SizedBox.shrink();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: related.length,
                      itemBuilder: (context, index) {
                        final ch = related[index];
                        final isCurrent = ch.id == currentChannelId;
                        return _ServerChip(
                          label: ch.name,
                          isCurrent: isCurrent,
                          onTap: () => onChannelSelected(ch.id),
                        );
                      },
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServerChip extends StatelessWidget {
  final String label;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ServerChip({
    required this.label,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: isCurrent ? null : onTap,
          child: DecoratedBox(
            decoration: isCurrent ? _kChipDecoActive : _kChipDecoInactive,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                label,
                style: isCurrent ? _kChipActiveStyle : _kChipInactiveStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
