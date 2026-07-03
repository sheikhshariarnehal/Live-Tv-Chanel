import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/player/channel_video_player.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String channelId;
  const PlayerScreen({super.key, required this.channelId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late String _currentChannelId;
  bool _controlsVisible = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _startControlsTimer();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _onPlayerTap() {
    setState(() {
      _controlsVisible = !_controlsVisible;
      if (_controlsVisible) {
        _startControlsTimer();
      } else {
        _controlsTimer?.cancel();
      }
    });
  }

  void _toggleFullscreen() {
    final isFullscreen = MediaQuery.of(context).orientation == Orientation.landscape;
    if (!isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    setState(() {
      _controlsVisible = true;
    });
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Widget _buildGlassBackButton(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(90),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withAlpha(20),
                width: 0.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelDetailsCard(Channel channel) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: GoPlayTheme.cardBorder,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: GoPlayTheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: channel.isLive
                    ? GoPlayTheme.primary.withAlpha(60)
                    : GoPlayTheme.cardBorder,
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: channel.logo != null && channel.logo!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: channel.logo!,
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                      placeholder: (context, url) => _buildInitials(channel.name, false),
                      errorWidget: (context, url, error) => _buildInitials(channel.name, false),
                    )
                  : _buildInitials(channel.name, false),
            ),
          ),
          const SizedBox(width: 14),
          // Name and badge info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        channel.name,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (channel.isLive) ...[
                      const SizedBox(width: 8),
                      const LiveBadge(),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                // Badges Row
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (channel.quality != null)
                      _buildBadge(
                        text: channel.quality!,
                        backgroundColor: GoPlayTheme.primary.withAlpha(25),
                        textColor: GoPlayTheme.primary,
                      ),
                    if (channel.category != null && channel.category!.isNotEmpty)
                      _buildBadge(
                        text: channel.category!.toUpperCase(),
                        backgroundColor: GoPlayTheme.surfaceContainerHighest,
                        textColor: GoPlayTheme.onSurfaceVariant,
                      ),
                    if (channel.country != null && channel.country!.isNotEmpty)
                      _buildBadge(
                        text: channel.country!,
                        backgroundColor: GoPlayTheme.surfaceContainerHighest,
                        textColor: GoPlayTheme.onSurfaceVariant,
                      ),
                    if (channel.hasDrm)
                      _buildBadge(
                        text: 'DRM',
                        backgroundColor: Colors.orange.withAlpha(30),
                        textColor: Colors.orange,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: textColor.withAlpha(30),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitcherTile(Channel ch, bool isCurrent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent 
            ? GoPlayTheme.primary.withAlpha(15) 
            : GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent 
              ? GoPlayTheme.primary.withAlpha(60) 
              : GoPlayTheme.cardBorder,
          width: isCurrent ? 1.0 : 0.5,
        ),
        boxShadow: isCurrent 
            ? [
                BoxShadow(
                  color: GoPlayTheme.primary.withAlpha(10),
                  blurRadius: 8,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isCurrent 
                ? GoPlayTheme.primary.withAlpha(20) 
                : GoPlayTheme.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? GoPlayTheme.primary.withAlpha(100) : GoPlayTheme.cardBorder,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: ch.logo != null && ch.logo!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: ch.logo!,
                    fit: BoxFit.cover,
                    width: 42,
                    height: 42,
                    placeholder: (context, url) => _buildInitials(ch.name, isCurrent),
                    errorWidget: (context, url, error) => _buildInitials(ch.name, isCurrent),
                  )
                : _buildInitials(ch.name, isCurrent),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                ch.name,
                style: TextStyle(
                  color: isCurrent ? GoPlayTheme.primary : GoPlayTheme.onSurface,
                  fontSize: 13,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              const _PlayingEqualizer(),
            ],
          ],
        ),
        subtitle: Row(
          children: [
            if (ch.quality != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isCurrent 
                      ? GoPlayTheme.primary.withAlpha(25) 
                      : GoPlayTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ch.quality!,
                  style: TextStyle(
                    color: isCurrent ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                '${ch.category ?? ''} • ${ch.country ?? ''}',
                style: TextStyle(
                  color: isCurrent 
                      ? GoPlayTheme.primary.withAlpha(150) 
                      : GoPlayTheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: isCurrent
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: GoPlayTheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GoPlayTheme.primary, width: 0.5),
                ),
                child: const Text(
                  'PLAYING',
                  style: TextStyle(
                    color: GoPlayTheme.primary,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            : (ch.isLive
                ? Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: GoPlayTheme.liveBadge,
                      shape: BoxShape.circle,
                    ),
                  )
                : null),
        onTap: isCurrent 
            ? null 
            : () {
                setState(() {
                  _currentChannelId = ch.id;
                });
              },
      ),
    );
  }

  Widget _buildInitials(String name, bool isCurrent) {
    final initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: isCurrent ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelAsync = ref.watch(channelProvider(_currentChannelId));
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final isFullscreen = MediaQuery.of(context).orientation == Orientation.landscape;

    return PopScope(
      canPop: !isFullscreen,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _toggleFullscreen();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: channelAsync.when(
          data: (channel) {
            if (channel == null) {
              return const Center(
                child: Text('Channel not found', style: TextStyle(color: Colors.white)),
              );
            }

            // Add to watch history
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(watchHistoryProvider.notifier).addChannel(channel);
            });

            // DESKTOP LAYOUT (Side-by-side)
            if (isDesktop && !isFullscreen) {
              return Row(
                children: [
                  // Left side: Video player
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: Colors.black,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _onPlayerTap,
                        child: Stack(
                          children: [
                            ChannelVideoPlayer.create(
                              channel: channel,
                              isFullscreen: isFullscreen,
                              onFullscreenToggle: _toggleFullscreen,
                              showControls: _controlsVisible,
                              onTap: _onPlayerTap,
                            ),

                            // Glass Back Button overlaid at top left
                            Positioned(
                              top: 16,
                              left: 16,
                              child: IgnorePointer(
                                ignoring: !_controlsVisible,
                                child: AnimatedOpacity(
                                  opacity: _controlsVisible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 250),
                                  child: _buildGlassBackButton(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Vertical Divider
                  Container(
                    width: 0.5,
                    color: GoPlayTheme.cardBorder,
                  ),

                  // Right side: Info and switcher
                  SizedBox(
                    width: 360,
                    child: Container(
                      color: GoPlayTheme.surface,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Premium Channel Details Card
                            _buildChannelDetailsCard(channel),

                            const Divider(
                              color: GoPlayTheme.cardBorder,
                              height: 1,
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Text(
                                'SWITCH CHANNEL',
                                style: TextStyle(
                                  color: GoPlayTheme.onSurfaceVariant,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            Expanded(
                              child: _RelatedChannelsList(
                                category: channel.category ?? '',
                                currentChannelId: channel.id,
                                isDesktopLayout: true,
                                tileBuilder: _buildSwitcherTile,
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

            // MOBILE / PORTRAIT LAYOUT (Also landscape fullscreen)
            return Column(
              children: [
                // Video Player Area
                Expanded(
                  flex: isFullscreen ? 1 : 0,
                  child: SafeArea(
                    top: !isFullscreen,
                    bottom: false,
                    left: false,
                    right: false,
                    child: Container(
                      height: isFullscreen ? double.infinity : 240,
                      width: double.infinity,
                      color: Colors.black,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _onPlayerTap,
                        child: Stack(
                          children: [
                            ChannelVideoPlayer.create(
                              channel: channel,
                              isFullscreen: isFullscreen,
                              onFullscreenToggle: _toggleFullscreen,
                              showControls: _controlsVisible,
                              onTap: _onPlayerTap,
                            ),

                            // Glass Back Button Overlay (Portrait mode only)
                            if (!isFullscreen)
                              Positioned(
                                top: 12,
                                left: 12,
                                child: IgnorePointer(
                                  ignoring: !_controlsVisible,
                                  child: AnimatedOpacity(
                                    opacity: _controlsVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child: _buildGlassBackButton(context),
                                  ),
                                ),
                              ),

                            // Fullscreen Top Servers Bar (Landscape mode / Full view player)
                            if (isFullscreen)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  ignoring: !_controlsVisible,
                                  child: AnimatedOpacity(
                                    opacity: _controlsVisible ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child: _FullscreenTopBar(
                                      category: channel.category ?? '',
                                      currentChannelId: channel.id,
                                      onBackPressed: _toggleFullscreen,
                                      onChannelSelected: (id) {
                                        setState(() {
                                          _currentChannelId = id;
                                        });
                                        _startControlsTimer();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Channel info + related channels (portrait only)
                if (!isFullscreen)
                  Expanded(
                    child: Container(
                      color: GoPlayTheme.surface,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // Current channel info card
                          _buildChannelDetailsCard(channel),

                          const Divider(
                            color: GoPlayTheme.cardBorder,
                            height: 1,
                          ),

                          // Related channels header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'SWITCH CHANNEL',
                              style: TextStyle(
                                color: GoPlayTheme.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          // Related channels list (Optimized & Isolated)
                          _RelatedChannelsList(
                            category: channel.category ?? '',
                            currentChannelId: channel.id,
                            isDesktopLayout: false,
                            tileBuilder: _buildSwitcherTile,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary),
          ),
          error: (e, s) => Center(
            child: Text('Error: $e', style: const TextStyle(color: GoPlayTheme.error)),
          ),
        ),
      ),
    );
  }
}

class _RelatedChannelsList extends ConsumerWidget {
  final String category;
  final String currentChannelId;
  final bool isDesktopLayout;
  final Widget Function(Channel ch, bool isCurrent) tileBuilder;

  const _RelatedChannelsList({
    required this.category,
    required this.currentChannelId,
    required this.isDesktopLayout,
    required this.tileBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return channelsAsync.when(
      data: (channels) {
        final related = channels
            .where((c) => c.category == category)
            .toList();

        if (related.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No other channels in this category',
                style: TextStyle(
                    color: GoPlayTheme.onSurfaceVariant,
                    fontSize: 13),
              ),
            ),
          );
        }

        if (isDesktopLayout) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: related.length,
            itemBuilder: (context, index) {
              final ch = related[index];
              final isCurrent = ch.id == currentChannelId;
              return tileBuilder(ch, isCurrent);
            },
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: related.map((ch) {
              final isCurrent = ch.id == currentChannelId;
              return tileBuilder(ch, isCurrent);
            }).toList(),
          );
        }
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(color: GoPlayTheme.primary),
        ),
      ),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

class _FullscreenTopBar extends ConsumerWidget {
  final String category;
  final String currentChannelId;
  final VoidCallback onBackPressed;
  final Function(String) onChannelSelected;

  const _FullscreenTopBar({
    required this.category,
    required this.currentChannelId,
    required this.onBackPressed,
    required this.onChannelSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withAlpha(220),
            Colors.black.withAlpha(120),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Container(
          height: 62,
          padding: const EdgeInsets.only(left: 6, right: 12, top: 14, bottom: 4),
          child: Row(
            children: [
              // Clean back icon
              GestureDetector(
                onTap: onBackPressed,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Scrollable servers list
              Expanded(
                child: channelsAsync.when(
                  data: (channels) {
                    final related = channels
                        .where((c) => c.category == category)
                        .toList();

                    if (related.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: related.length,
                      itemBuilder: (context, index) {
                        final ch = related[index];
                        final isCurrent = ch.id == currentChannelId;

                        return _ServerPill(
                          channel: ch,
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

class _ServerPill extends StatelessWidget {
  final Channel channel;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ServerPill({
    required this.channel,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: GestureDetector(
        onTap: isCurrent ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrent
                  ? GoPlayTheme.primary
                  : Colors.white.withAlpha(80),
              width: 1.0,
            ),
          ),
          child: Text(
            channel.name.toUpperCase(),
            style: TextStyle(
              color: isCurrent ? GoPlayTheme.primary : Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayingEqualizer extends StatefulWidget {
  const _PlayingEqualizer();

  @override
  State<_PlayingEqualizer> createState() => _PlayingEqualizerState();
}

class _PlayingEqualizerState extends State<_PlayingEqualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      width: 11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double multiplier = 1.0;
              if (index == 0) {
                multiplier = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi);
              } else if (index == 1) {
                multiplier = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi + (2 / 3 * math.pi));
              } else {
                multiplier = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi + (4 / 3 * math.pi));
              }
              double height = 2 + 8 * multiplier.abs();
              return Container(
                width: 2.5,
                height: height,
                decoration: BoxDecoration(
                  color: GoPlayTheme.primary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
