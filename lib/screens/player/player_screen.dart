import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../widgets/player/channel_video_player.dart';

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

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _startControlsTimer();

    if (widget.forceFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
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
    setState(() => _controlsVisible = true);
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _addToHistory(Channel channel) {
    if (_lastHistoryChannelId != channel.id) {
      _lastHistoryChannelId = channel.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(watchHistoryProvider.notifier).addChannel(channel);
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
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (widget.forceFullscreen) {
          Navigator.of(context).pop();
        } else {
          _toggleFullscreen();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: channelsAsync.when(
          data: (channels) {
            final channel = channels.cast<Channel?>().firstWhere(
                  (c) => c?.id == _currentChannelId,
                  orElse: () => null,
                );

            if (channel == null) {
              return const Center(
                child: Text('Channel not found', style: TextStyle(color: Colors.white)),
              );
            }

            _addToHistory(channel);

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
                    ),
                  ),
                  const VerticalDivider(width: 0.5, thickness: 0.5, color: GoPlayTheme.cardBorder),
                  SizedBox(
                    width: 360,
                    child: ColoredBox(
                      color: GoPlayTheme.surface,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ChannelInfoBar(channel: channel),
                            const Divider(color: GoPlayTheme.cardBorder, height: 1),
                            const _SectionLabel(text: 'SWITCH CHANNEL'),
                            Expanded(
                              child: _RelatedChannelsList(
                                category: channel.category ?? '',
                                currentChannelId: channel.id,
                                isScrollable: true,
                                onChannelSelected: (id) => setState(() => _currentChannelId = id),
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
            return Column(
              children: [
                Expanded(
                  flex: isFullscreen ? 1 : 0,
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
                if (!isFullscreen)
                  Expanded(
                    child: ColoredBox(
                      color: GoPlayTheme.surface,
                      child: SafeArea(
                        top: false,
                        bottom: true,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            _ChannelInfoBar(channel: channel),
                            const Divider(color: GoPlayTheme.cardBorder, height: 1),
                            const _SectionLabel(text: 'SWITCH CHANNEL'),
                            _RelatedChannelsList(
                              category: channel.category ?? '',
                              currentChannelId: channel.id,
                              isScrollable: false,
                              onChannelSelected: (id) => setState(() => _currentChannelId = id),
                              eventChannels: widget.eventChannels,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2),
          ),
          error: (e, s) => Center(
            child: Text('Error: $e', style: const TextStyle(color: GoPlayTheme.error)),
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

  const _PlayerContainer({
    required this.channel,
    required this.isFullscreen,
    required this.controlsVisible,
    required this.onTap,
    required this.onFullscreenToggle,
    this.showBackButton = false,
    this.topBar,
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
              ),
            ),

            // Back button
            if (showBackButton)
              Positioned(
                top: 12,
                left: 12,
                child: IgnorePointer(
                  ignoring: !controlsVisible,
                  child: AnimatedOpacity(
                    opacity: controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const _BackButton(),
                  ),
                ),
              ),

            // Fullscreen top bar
            if (topBar != null)
              Positioned(
                top: 0, left: 0, right: 0,
                child: IgnorePointer(
                  ignoring: !controlsVisible,
                  child: AnimatedOpacity(
                    opacity: controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
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

// ─── Back Button (lightweight, no BackdropFilter) ───────────────

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12, width: 0.5),
        ),
        child: const SizedBox(
          width: 32,
          height: 32,
          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}

// ─── Channel Info Bar (compact) ─────────────────────────────────

class _ChannelInfoBar extends StatelessWidget {
  final Channel channel;
  const _ChannelInfoBar({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          _ChannelAvatar(name: channel.name, logo: channel.logo, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  channel.name,
                  style: const TextStyle(
                    color: GoPlayTheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _MetadataRow(channel: channel),
              ],
            ),
          ),
        ],
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
    return Wrap(
      spacing: 5,
      runSpacing: 3,
      children: [
        if (channel.quality != null)
          _Pill(channel.quality!, GoPlayTheme.primary.withAlpha(25), GoPlayTheme.primary),
        if (channel.category != null && channel.category!.isNotEmpty)
          _Pill(channel.category!.toUpperCase(), GoPlayTheme.surfaceContainerHighest, GoPlayTheme.onSurfaceVariant),
        if (channel.country != null && channel.country!.isNotEmpty)
          _Pill(channel.country!, GoPlayTheme.surfaceContainerHighest, GoPlayTheme.onSurfaceVariant),
        if (channel.hasDrm)
          _Pill('DRM', Colors.orange.withAlpha(30), Colors.orange),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Pill(this.text, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          text,
          style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        text,
        style: const TextStyle(
          color: GoPlayTheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
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
    final textStyle = TextStyle(
      color: GoPlayTheme.onSurfaceVariant,
      fontSize: size * 0.28,
      fontWeight: FontWeight.w800,
    );

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(color: GoPlayTheme.cardBorder, width: 1),
        ),
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
                  placeholder: (_, __) => Center(child: Text(initials, style: textStyle)),
                  errorWidget: (_, __, ___) => Center(child: Text(initials, style: textStyle)),
                )
              : Center(child: Text(initials, style: textStyle)),
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
          related = channels.where((c) => eventChannels!.contains(c.id)).toList();
        } else {
          related = channels.where((c) => c.category == category).toList();
        }

        if (related.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No other channels in this category',
                style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: 13),
              ),
            ),
          );
        }

        if (isScrollable) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: related.length,
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
        child: Center(child: CircularProgressIndicator(color: GoPlayTheme.primary, strokeWidth: 2)),
      ),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

// ─── Channel Tile (flat, minimal depth) ─────────────────────────

class _ChannelTile extends StatelessWidget {
  final Channel channel;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ChannelTile({
    required this.channel,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isCurrent ? GoPlayTheme.primary.withAlpha(12) : GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: isCurrent ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _ChannelAvatar(name: channel.name, logo: channel.logo, size: 36),
                const SizedBox(width: 10),
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
                            const SizedBox(width: 6),
                            const _EqualizerBars(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [channel.quality, channel.category, channel.country]
                            .where((s) => s != null && s.isNotEmpty)
                            .join(' · '),
                        style: TextStyle(
                          color: isCurrent ? GoPlayTheme.primary.withAlpha(140) : GoPlayTheme.onSurfaceVariant,
                          fontSize: 10.5,
                        ),
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
    );
  }

  Widget _buildPlayingTag() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GoPlayTheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          'PLAYING',
          style: TextStyle(color: GoPlayTheme.primary, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.4),
        ),
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
        decoration: BoxDecoration(color: GoPlayTheme.liveBadge, shape: BoxShape.circle),
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

class _EqualizerBarsState extends State<_EqualizerBars> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat();
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
      final h = 2 + 8 * (0.5 + 0.5 * math.sin(animation.value * 2 * math.pi + phase)).abs();
      final x = i * (barW + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - h, barW, h), const Radius.circular(1.5)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_EqualizerPainter old) => false; // repaint driven by animation listener
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xDC000000), Color(0x78000000), Colors.transparent],
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 12, top: 12, bottom: 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBackPressed,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: channelsAsync.when(
                    data: (channels) {
                      final List<Channel> related;
                      if (eventChannels != null) {
                        related = channels.where((c) => eventChannels!.contains(c.id)).toList();
                      } else {
                        related = channels.where((c) => c.category == category).toList();
                      }
                      if (related.isEmpty) return const SizedBox.shrink();
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
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

class _ServerChip extends StatelessWidget {
  final String label;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ServerChip({required this.label, required this.isCurrent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: GestureDetector(
        onTap: isCurrent ? null : onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isCurrent ? GoPlayTheme.primary : Colors.white24,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Center(
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: isCurrent ? GoPlayTheme.primary : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
