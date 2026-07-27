import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../widgets/player/channel_video_player.dart';
import '../../widgets/tv_focus_wrapper.dart';

// ─── Pre-cached top-level constants — zero per-frame allocations ─

const _kScreenBg = BoxDecoration(color: GoPlayTheme.surface);

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
    BoxShadow(color: Color(0x1F00ADB5), blurRadius: 8, offset: Offset(0, 2)),
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

// Playing tag
const _kPlayingTagDeco = BoxDecoration(
  color: Color(0x1A00ADB5),
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: Color(0x3200ADB5), width: 0.5),
  ),
);
const _kPlayingTagStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 8,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.4,
);

// Server chip decorations
final _kChipDecoActive = BoxDecoration(
  gradient: const LinearGradient(
    colors: [
      Color(0xFF00E5EE), // Bright cyan/teal gloss top
      Color(0xFF00ADB5), // Brand teal base
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  borderRadius: const BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: Colors.white.withValues(alpha: 0.35), width: 1.0),
  ),
);
final _kChipDecoInactive = BoxDecoration(
  color: Colors.white.withValues(alpha: 0.18), // Increased opacity for better visibility
  borderRadius: const BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: Colors.white.withValues(alpha: 0.28), width: 0.8),
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

const _kSectionLabelStyle = TextStyle(
  color: Colors.white60,
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
);

const _kTileNameActiveStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 13.5,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
const _kTileNameNormalStyle = TextStyle(
  color: Colors.white,
  fontSize: 13.5,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

const _kTileMetaActiveStyle = TextStyle(
  color: Color(0xCC00ADB5),
  fontSize: 10.5,
);
const _kTileMetaNormalStyle = TextStyle(color: Colors.white38, fontSize: 10.5);
const _kChipActiveStyle = TextStyle(
  color: Colors.black,
  fontSize: 11.5,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
const _kChipInactiveStyle = TextStyle(
  color: Colors.white, // Increased text opacity for maximum readability
  fontSize: 11.5,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
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
  bool _isFullViewMode = false;
  Timer? _controlsTimer;
  String? _lastHistoryChannelId;
  static const _pipChannel = MethodChannel('com.goplay/pip');
  bool _isTvDevice = false; // Set once in first build, used to skip orientation locks

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _startControlsTimer();

    // Keep screen awake while player is active
    WakelockPlus.enable();

    if (widget.forceFullscreen) {
      _isFullViewMode = true;
      // Orientation lock deferred to first build() where we can detect TV
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyFullscreenOrientation();
      });
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
    setState(() {
      _isFullViewMode = !_isFullViewMode;
      _controlsVisible = true;
    });

    if (_isFullViewMode) {
      _applyFullscreenOrientation();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _safeSetOrientation(DeviceOrientation.values);
    }
    _startControlsTimer();
  }

  /// Apply fullscreen orientation lock — skipped on TV devices (always landscape)
  void _applyFullscreenOrientation() {
    if (!_isTvDevice) {
      _safeSetOrientation([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Wraps setPreferredOrientations in try-catch — some TV dongles/sticks
  /// throw PlatformException when you try to lock orientation.
  void _safeSetOrientation(List<DeviceOrientation> orientations) {
    try {
      SystemChrome.setPreferredOrientations(orientations);
    } catch (_) {
      // Silently ignore on TV devices that don't support orientation changes
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _pipChannel.invokeMethod('setPlayerActive', false);
    _pipChannel.setMethodCallHandler(null);
    // Allow screen to sleep again when leaving the player
    WakelockPlus.disable();
    _safeSetOrientation(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Stop tracking active channel
    ref.read(analyticsServiceProvider).stopWatching();
    
    super.dispose();
  }

  void _addToHistory(Channel channel) {
    if (_lastHistoryChannelId != channel.id) {
      _lastHistoryChannelId = channel.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(watchHistoryProvider.notifier).addChannel(channel);
          // Track active channel playback
          ref.read(analyticsServiceProvider).startWatching(channel.id, channel.name);
        }
      });
    }
  }

  /// Handles only screen-level keys that the inner player widget does NOT own:
  ///  - F key  → toggle full-view mode
  ///  - Escape / Back → exit full-view or hide controls
  ///
  /// All other keys (arrows, select, media) are left `ignored` so they
  /// bubble down to the inner ChannelVideoPlayerNative Focus node which
  /// owns seek, play/pause, and channel-zap behaviour.
  KeyEventResult _handlePlayerKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final lKey = event.logicalKey;
    final pKey = event.physicalKey;

    // F key → toggle full-view mode
    if (lKey == LogicalKeyboardKey.keyF ||
        pKey == PhysicalKeyboardKey.keyF) {
      _toggleFullscreen();
      return KeyEventResult.handled;
    }

    // Escape / Back → exit full-view first, then hide controls
    if (lKey == LogicalKeyboardKey.goBack ||
        lKey == LogicalKeyboardKey.escape) {
      if (_isFullViewMode) {
        _toggleFullscreen();
        return KeyEventResult.handled;
      }
      // Don't handle — let it pop the route normally
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);
    final mq = MediaQuery.of(context);
    // TV detection: matches improved logic from ShellScreen
    final isTv = mq.navigationMode == NavigationMode.directional ||
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional ||
        mq.size.shortestSide >= 960;
    // Cache TV detection for orientation logic (only set once)
    if (!_isTvDevice && isTv) _isTvDevice = true;
    final isLandscape = mq.orientation == Orientation.landscape || mq.size.width > mq.size.height;
    final isWide = isTv || isLandscape || mq.size.width >= 600;
    final isFullscreen = _isFullViewMode || widget.forceFullscreen;
    final maxPlayerH = mq.size.height * 0.45;
    final responsivePlayerHeight = (mq.size.width * 9 / 16).clamp(maxPlayerH < 180.0 ? maxPlayerH : 180.0, maxPlayerH);

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
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: _handlePlayerKeyEvent,
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
                  ? widget.eventChannels!
                        .map((id) {
                          final match = channels.where((c) => c.id == id);
                          return match.isNotEmpty ? match.first : null;
                        })
                        .whereType<Channel>()
                        .toList()
                  : channels
                        .where((c) => c.category == channel.category)
                        .toList();

              final currentIndex = relatedChannels.indexWhere(
                (c) => c.id == channel.id,
              );
              final prevChannel = (currentIndex > 0)
                  ? relatedChannels[currentIndex - 1]
                  : null;
              final nextChannel =
                  (currentIndex != -1 &&
                      currentIndex < relatedChannels.length - 1)
                  ? relatedChannels[currentIndex + 1]
                  : null;

              final onPrev = prevChannel != null
                  ? () {
                      setState(() {
                        _currentChannelId = prevChannel.id;
                      });
                      _startControlsTimer();
                    }
                  : null;

              final onNext = nextChannel != null
                  ? () {
                      setState(() {
                        _currentChannelId = nextChannel.id;
                      });
                      _startControlsTimer();
                    }
                  : null;

              // WIDESCREEN / TV RESPONSIVE SPLIT LAYOUT (NON-FULLSCREEN)
              if (isWide && !isFullscreen) {
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
                      width: mq.size.width > 1100 ? 380 : 320,
                      child: DecoratedBox(
                        decoration: _kSidePanelDeco,
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

              // PORTRAIT / MOBILE LAYOUT (also handles fullscreen)
              // Both children always exist in the Stack to preserve
              // widget identity and prevent AndroidView recreation.
              return Stack(
                children: [
                  // 1. Channel list — always present, hidden via Offstage
                  Positioned.fill(
                    child: Offstage(
                      offstage: isFullscreen,
                      child: Column(
                        children: [
                          SizedBox(
                            height: mq.padding.top + responsivePlayerHeight,
                          ), // Placeholder for the player
                          Expanded(
                            child: SafeArea(
                              top: false,
                              bottom: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                        ],
                      ),
                    ),
                  ),

                  // 2. The Video Player — same tree position, same constraint type
                  Positioned(
                    top: isFullscreen ? 0 : mq.padding.top,
                    left: 0,
                    right: 0,
                    height: isFullscreen ? mq.size.height : responsivePlayerHeight,
                    child: _PlayerContainer(
                      channel: channel,
                      isFullscreen: isFullscreen,
                      controlsVisible: _controlsVisible,
                      onTap: _onPlayerTap,
                      onFullscreenToggle: _toggleFullscreen,
                      showBackButton: false,
                      onPreviousChannel: onPrev,
                      onNextChannel: onNext,
                      onInteract: _onPlayerInteract,
                      height: responsivePlayerHeight,
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
    ),
    );
  }
}

// ─── Player Container (isolated repaints) ───────────────────────

class _PlayerContainer extends StatelessWidget {
  final Channel channel;
  final bool isFullscreen;
  final double? height;
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
    this.height,
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
      height: isFullscreen ? double.infinity : (height ?? double.infinity),
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
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Colors.white,
      ),
      iconSize: 24,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
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
        child: logo != null && logo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logo!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                memCacheWidth: (size * 2).toInt(),
                memCacheHeight: (size * 2).toInt(),
                fadeInDuration: const Duration(milliseconds: 150),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
          related = eventChannels!
              .map((id) {
                final match = channels.where((c) => c.id == id);
                return match.isNotEmpty ? match.first : null;
              })
              .whereType<Channel>()
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
                key: ValueKey(ch.id),
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
    super.key,
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
      child: TvFocusable(
        borderRadius: BorderRadius.circular(16),
        onTap: isCurrent ? null : widget.onTap,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 6.0),
          child: SizedBox(
            height: 52,
            child: Row(
              children: [
                // 1. Back button
                TvFocusable(
                  isCircle: true,
                  onTap: onBackPressed,
                  child: IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    iconSize: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: const BoxConstraints(),
                  ),
                ),

                // 2. Horizontal Channels list
                Expanded(
                  child: channelsAsync.when(
                    data: (channels) {
                      final List<Channel> related;
                      if (eventChannels != null) {
                        related = eventChannels!
                            .map((id) {
                              final match = channels.where((c) => c.id == id);
                              return match.isNotEmpty ? match.first : null;
                            })
                            .whereType<Channel>()
                            .toList();
                      } else {
                        related = channels
                            .where((c) => c.category == category)
                            .toList();
                      }
                      if (related.isEmpty) return const SizedBox.shrink();
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 4, right: 16),
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
      ),
    );
  }
}

class _ServerChip extends StatefulWidget {
  final String label;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ServerChip({
    required this.label,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  State<_ServerChip> createState() => _ServerChipState();
}

class _ServerChipState extends State<_ServerChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TvFocusable(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.isCurrent ? null : widget.onTap,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.isCurrent ? null : widget.onTap,
            child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: widget.isCurrent ? _kChipDecoActive : _kChipDecoInactive,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                child: Text(
                  widget.label,
                  style: widget.isCurrent ? _kChipActiveStyle : _kChipInactiveStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
