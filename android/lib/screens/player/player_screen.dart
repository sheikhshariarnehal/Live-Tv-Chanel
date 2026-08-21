import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
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
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.primary,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w800,
  height: GoPlayType.leadingFlat,
  letterSpacing: GoPlayType.trackingMeta,
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
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.darkOnSurfaceVariant,
  fontSize: GoPlayType.sm,
  fontWeight: FontWeight.w700,
  height: GoPlayType.leadingFlat,
  letterSpacing: GoPlayType.trackingWide,
);

const _kTileNameActiveStyle = TextStyle(
  fontFamily: GoPlayType.family,
  height: GoPlayType.leadingSnug,
  color: GoPlayTheme.primary,
  fontSize: GoPlayType.base,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
const _kTileNameNormalStyle = TextStyle(
  fontFamily: GoPlayType.family,
  height: GoPlayType.leadingSnug,
  color: GoPlayTheme.darkOnSurface,
  fontSize: GoPlayType.base,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

const _kTileMetaActiveStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.primary,
  fontSize: GoPlayType.xs,
  height: GoPlayType.leadingSnug,
);
const _kTileMetaNormalStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.darkOnSurfaceMuted,
  fontSize: GoPlayType.xs,
  height: GoPlayType.leadingSnug,
);
const _kChipActiveStyle = TextStyle(
  fontFamily: GoPlayType.family,
  height: GoPlayType.leadingSnug,
  color: GoPlayTheme.darkOnPrimary,
  fontSize: GoPlayType.sm,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.1,
);
const _kChipInactiveStyle = TextStyle(
  fontFamily: GoPlayType.family,
  height: GoPlayType.leadingSnug,
  color: GoPlayTheme.darkOnSurface,
  fontSize: GoPlayType.sm,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
);

// Cached identity matrix — never reallocated
final _kIdentityMatrix = Matrix4.identity();
final _kHoverMatrix = Matrix4.translationValues(0.0, -1.0, 0.0);

class PlayerScreen extends ConsumerStatefulWidget {
  final String channelId;

  /// The ordered channel list this player session is scoped to.
  ///
  /// Despite the name this is not only an event's channels — it is "the list
  /// the user came from", and it drives prev/next, the side panel, and the
  /// top-bar chips. An event passes its own channels; the Home rails pass the
  /// rail they were tapped in.
  ///
  /// When null, the player falls back to every channel sharing the current
  /// channel's category. That fallback is right for the category grid and
  /// search, and wrong for any curated list — a caller that renders a specific
  /// set of channels must pass that set here, or the user will be dropped into
  /// the whole category on the first channel switch.
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

  // ── TV Panel Focus Routing ──────────────────────────────────────
  // Dedicated focus scope for the channel-list side panel.
  // When the user presses D-Pad Right from the player, focus shifts here.
  // When the user presses D-Pad Left from the channel list, focus returns to player.
  final FocusScopeNode _channelPanelFocusScope = FocusScopeNode(debugLabel: 'ChannelPanelScope');
  final FocusNode _playPauseFocusNode = FocusNode(debugLabel: 'PlayPauseFocusNode');
  // Exposed to the inner ChannelVideoPlayerNative so it can call
  // _channelPanelFocusScope.requestFocus() when D-Pad Right is pressed.
  bool _channelPanelHasFocus = false;

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

    // Only enable PiP on app minimize when in Full View mode
    _pipChannel.invokeMethod('setPlayerActive', widget.forceFullscreen);
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
    // Use a longer hide delay on TV — remote navigation is slower than touch
    final delay = _isTvDevice ? const Duration(seconds: 8) : const Duration(seconds: 4);
    _controlsTimer = Timer(delay, () {
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

    // Toggle PiP mode on minimize — only active in Full View mode
    _pipChannel.invokeMethod('setPlayerActive', _isFullViewMode);

    if (_isFullViewMode) {
      _applyFullscreenOrientation();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _safeSetOrientation(DeviceOrientation.values);
    }
    _startControlsTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playPauseFocusNode.requestFocus();
      }
    });
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
    _channelPanelFocusScope.dispose();
    _playPauseFocusNode.dispose();
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

  /// Screen-level key handler.
  ///
  /// Handles:
  ///  - F key          → toggle full-view mode
  ///  - Escape / Back  → exit full-view or pop
  ///
  /// All other keys bubble to the inner ChannelVideoPlayerNative FocusNode.
  KeyEventResult _handlePlayerKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    // TV Remote Wake-Up: If player controls have auto-hidden, ANY remote key press
    // immediately shows all controls, focuses Play/Pause, and starts the 8s timer.
    if (!_controlsVisible) {
      setState(() {
        _controlsVisible = true;
      });
      _startControlsTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _playPauseFocusNode.requestFocus();
        }
      });
      return KeyEventResult.handled;
    }

    final lKey = event.logicalKey;
    final pKey = event.physicalKey;

    // F key → toggle full-view mode
    if (lKey == LogicalKeyboardKey.keyF ||
        pKey == PhysicalKeyboardKey.keyF) {
      _toggleFullscreen();
      return KeyEventResult.handled;
    }

    // Escape / Back → exit full-view first, then pop
    if (lKey == LogicalKeyboardKey.goBack ||
        lKey == LogicalKeyboardKey.escape) {
      if (_isFullViewMode) {
        _toggleFullscreen();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  /// Called by [ChannelVideoPlayerNative] when D-Pad Right is pressed
  /// and the user wants to shift focus to the channel list panel.
  void _focusChannelPanel() {
    if (!_channelPanelHasFocus) {
      // Make controls visible so the panel is visible
      setState(() {
        _controlsVisible = true;
        _channelPanelHasFocus = true;
      });
      _controlsTimer?.cancel();
      // Request focus on the side-panel scope
      _channelPanelFocusScope.requestFocus();
    }
  }

  /// Called by the channel panel's FocusScope when it loses focus back to player.
  void _focusPlayer() {
    if (_channelPanelHasFocus) {
      setState(() {
        _channelPanelHasFocus = false;
      });
      _startControlsTimer();
    }
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
      // Always allow pop — we handle full-view exit manually below
      canPop: !_isFullViewMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // canPop==false means we're in full-view mode — collapse it
        _toggleFullscreen();
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
                return Center(
                  child: Text(
                    'Channel not found',
                    style: GoPlayType.body.copyWith(color: GoPlayTheme.darkOnSurface),
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
                    // ── Player panel ──────────────────────────────
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
                        // TV: D-Pad Right from player → shift focus to channel panel
                        onFocusChannelPanel: isTv ? _focusChannelPanel : null,
                        isTvDevice: isTv,
                        playPauseFocusNode: _playPauseFocusNode,
                      ),
                    ),
                    const VerticalDivider(
                      width: 0.8,
                      thickness: 0.8,
                      color: Color(0x14FFFFFF),
                    ),

                    // ── Channel list side panel ────────────────────
                    // Wrapped in a FocusScope so we can route focus in/out cleanly.
                    FocusScope(
                      node: _channelPanelFocusScope,
                      onFocusChange: (hasFocus) {
                        // When the panel LOSES focus back to the player area
                        if (!hasFocus && _channelPanelHasFocus) {
                          _focusPlayer();
                        }
                      },
                      child: KeyboardListener(
                        focusNode: FocusNode(canRequestFocus: false),
                        onKeyEvent: (event) {
                          // D-Pad Left from channel list → return focus to player
                          if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
                              event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                            // Move focus back to player — find nearest sibling
                            FocusScope.of(context).previousFocus();
                            _focusPlayer();
                          }
                        },
                        child: SizedBox(
                          width: mq.size.width > 1100 ? 380 : 320,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: _channelPanelHasFocus
                                ? BoxDecoration(
                                    color: GoPlayTheme.surfaceContainerLow,
                                    border: const Border(
                                      left: BorderSide(color: GoPlayTheme.primary, width: 1.5),
                                    ),
                                  )
                                : _kSidePanelDeco,
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
                                      onChannelSelected: (id) {
                                        setState(() => _currentChannelId = id);
                                        // Return focus to player after switching channel
                                        if (isTv) _focusPlayer();
                                      },
                                      eventChannels: widget.eventChannels,
                                      panelHasFocus: _channelPanelHasFocus && isTv,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                // didUpdateWidget in ChannelVideoPlayer will
                                // auto-focus play/pause after channel change.
                              },
                              eventChannels: widget.eventChannels,
                              onFocusDown: () {
                                _playPauseFocusNode.requestFocus();
                              },
                              onInteract: _onPlayerInteract,
                            )
                          : null,
                      playPauseFocusNode: _playPauseFocusNode,
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
                style: GoPlayType.body.copyWith(color: GoPlayTheme.error),
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
  // TV-only: called when D-Pad Right is pressed to shift focus to channel list
  final VoidCallback? onFocusChannelPanel;
  final bool isTvDevice;
  final FocusNode? playPauseFocusNode;

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
    this.onFocusChannelPanel,
    this.isTvDevice = false,
    this.playPauseFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    // In fullscreen: wrap the entire stack in a FocusTraversalGroup so the
    // top bar (Back + channel chips) and the player controls (center + bottom)
    // all participate in ONE unified focus tree. ReadingOrderTraversalPolicy
    // traverses naturally top→bottom so D-Pad Up/Down moves between the 3 rows.
    final stack = SizedBox(
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
                onFocusChannelPanel: onFocusChannelPanel,
                isTvDevice: isTvDevice,
                playPauseFocusNode: playPauseFocusNode,
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

    if (!isFullscreen) return stack;

    // Fullscreen: wrap in a single FocusTraversalGroup so the top bar and
    // the player center/bottom controls are one contiguous focus scope that
    // Flutter can traverse with D-Pad Up/Down/Left/Right.
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: stack,
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
                    style: GoPlayType.inter(
                      color: GoPlayTheme.darkOnSurfaceVariant,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w800,
                      height: GoPlayType.leadingFlat,
                    ),
                  ),
                ),
                errorWidget: (context, url, err) => Center(
                  child: Text(
                    initials,
                    style: GoPlayType.inter(
                      color: GoPlayTheme.darkOnSurfaceVariant,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.w800,
                      height: GoPlayType.leadingFlat,
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  initials,
                  style: GoPlayType.inter(
                    color: GoPlayTheme.darkOnSurfaceVariant,
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w800,
                    height: GoPlayType.leadingFlat,
                  ),
                ),
              ),
      ),
    );
  }
}

class _RelatedChannelsList extends ConsumerStatefulWidget {
  final String category;
  final String currentChannelId;
  final bool isScrollable;
  final Function(String) onChannelSelected;
  final List<String>? eventChannels;
  /// When true (TV + panel has focus), the current playing or last-focused channel item gets autofocus
  final bool panelHasFocus;

  const _RelatedChannelsList({
    super.key,
    required this.category,
    required this.currentChannelId,
    required this.isScrollable,
    required this.onChannelSelected,
    this.eventChannels,
    this.panelHasFocus = false,
  });

  @override
  ConsumerState<_RelatedChannelsList> createState() => _RelatedChannelsListState();
}

class _RelatedChannelsListState extends ConsumerState<_RelatedChannelsList> {
  String? _lastFocusedChannelId;

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(channelsProvider);

    return channelsAsync.when(
      data: (channels) {
        final List<Channel> related;
        if (widget.eventChannels != null) {
          related = widget.eventChannels!
              .map((id) {
                final match = channels.where((c) => c.id == id);
                return match.isNotEmpty ? match.first : null;
              })
              .whereType<Channel>()
              .toList();
        } else {
          related = channels.where((c) => c.category == widget.category).toList();
        }

        if (related.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No other channels in this category',
                textAlign: TextAlign.center,
                style: GoPlayType.body.copyWith(color: GoPlayTheme.darkOnSurfaceMuted),
              ),
            ),
          );
        }

        // Target last focused channel if available; fallback to currently playing channel
        final targetId = _lastFocusedChannelId ?? widget.currentChannelId;
        int targetIdx = related.indexWhere((c) => c.id == targetId);
        if (targetIdx == -1) {
          targetIdx = related.indexWhere((c) => c.id == widget.currentChannelId);
        }
        if (targetIdx == -1) targetIdx = 0;

        final autoFocusIdx = widget.panelHasFocus ? targetIdx : -1;

        if (widget.isScrollable) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: related.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final ch = related[index];
              final isCurrent = ch.id == widget.currentChannelId;
              return _ChannelTile(
                key: ValueKey(ch.id),
                channel: ch,
                isCurrent: isCurrent,
                autoFocus: index == autoFocusIdx,
                onFocused: () {
                  _lastFocusedChannelId = ch.id;
                },
                onTap: () => widget.onChannelSelected(ch.id),
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
                isCurrent: ch.id == widget.currentChannelId,
                onTap: () => widget.onChannelSelected(ch.id),
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
  final bool autoFocus;
  final VoidCallback? onFocused;

  const _ChannelTile({
    super.key,
    required this.channel,
    required this.isCurrent,
    required this.onTap,
    this.autoFocus = false,
    this.onFocused,
  });

  @override
  State<_ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<_ChannelTile> {
  bool _isHovered = false;
  late final FocusNode _tileFocusNode;

  @override
  void initState() {
    super.initState();
    _tileFocusNode = FocusNode(debugLabel: 'TileFocus-${widget.channel.name}');
    _tileFocusNode.addListener(_onFocusChange);
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tileFocusNode.requestFocus();
      });
    }
  }

  void _onFocusChange() {
    if (_tileFocusNode.hasFocus) {
      widget.onFocused?.call();
    }
  }

  @override
  void didUpdateWidget(_ChannelTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoFocus && !oldWidget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tileFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _tileFocusNode.removeListener(_onFocusChange);
    _tileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.channel;
    final isCurrent = widget.isCurrent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TvFocusable(
        focusNode: _tileFocusNode,
        borderRadius: BorderRadius.circular(16),
        autoFocus: widget.autoFocus,
        onTap: widget.onTap,
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
                    name: channel.displayName,
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
                                channel.displayName,
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
  /// Called when D-Pad Down is pressed in the top bar, allowing the parent
  /// to move focus explicitly to the center player controls.
  final VoidCallback? onFocusDown;
  final VoidCallback? onInteract;

  const _FullscreenTopBar({
    required this.category,
    required this.currentChannelId,
    required this.onBackPressed,
    required this.onChannelSelected,
    this.eventChannels,
    this.onFocusDown,
    this.onInteract,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    final bar = DecoratedBox(
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
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
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
                            label: ch.displayName,
                            isCurrent: isCurrent,
                            onTap: () => onChannelSelected(ch.id),
                            onFocusDown: onFocusDown,
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

    if (onFocusDown == null) return bar;

    // Wrap bar in a Focus that intercepts D-Pad Down → move focus to
    // center controls explicitly, bypassing any Stack-traversal ambiguity.
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          onInteract?.call();
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.arrowDown) {
            onFocusDown!();
            return KeyEventResult.handled;
          }
          if (key == LogicalKeyboardKey.arrowUp) {
            // Prevent focus loss when pressing Up on top-most row!
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: bar,
    );
  }
}

class _ServerChip extends StatefulWidget {
  final String label;
  final bool isCurrent;
  final VoidCallback onTap;
  /// Optional: called when D-Pad Down is pressed while this chip is focused.
  final VoidCallback? onFocusDown;

  const _ServerChip({
    required this.label,
    required this.isCurrent,
    required this.onTap,
    this.onFocusDown,
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
