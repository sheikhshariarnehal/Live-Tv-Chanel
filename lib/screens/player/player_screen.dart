import 'dart:async';
import 'dart:math' as math;
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
  String? _lastHistoryChannelId;

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _startControlsTimer();
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

  // Lightweight back button — no BackdropFilter (GPU-heavy blur removed)
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12, width: 0.5),
        ),
        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 16),
      ),
    );
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
                      backButton: _buildBackButton(),
                      topBar: null,
                    ),
                  ),
                  Container(width: 0.5, color: GoPlayTheme.cardBorder),
                  SizedBox(
                    width: 360,
                    child: Container(
                      color: GoPlayTheme.surface,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ChannelDetailsCard(channel: channel),
                            const Divider(color: GoPlayTheme.cardBorder, height: 1),
                            const _SectionHeader(text: 'SWITCH CHANNEL'),
                            Expanded(
                              child: _RelatedChannelsList(
                                category: channel.category ?? '',
                                currentChannelId: channel.id,
                                isDesktopLayout: true,
                                onChannelSelected: (id) => setState(() => _currentChannelId = id),
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
                      backButton: isFullscreen ? null : _buildBackButton(),
                      topBar: isFullscreen
                          ? _FullscreenTopBar(
                              category: channel.category ?? '',
                              currentChannelId: channel.id,
                              onBackPressed: _toggleFullscreen,
                              onChannelSelected: (id) {
                                setState(() => _currentChannelId = id);
                                _startControlsTimer();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                if (!isFullscreen)
                  Expanded(
                    child: Container(
                      color: GoPlayTheme.surface,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _ChannelDetailsCard(channel: channel),
                          const Divider(color: GoPlayTheme.cardBorder, height: 1),
                          const _SectionHeader(text: 'SWITCH CHANNEL'),
                          _RelatedChannelsList(
                            category: channel.category ?? '',
                            currentChannelId: channel.id,
                            isDesktopLayout: false,
                            onChannelSelected: (id) => setState(() => _currentChannelId = id),
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

/// Isolated player container with RepaintBoundary — controls overlay
/// doesn't force the video surface to repaint.
class _PlayerContainer extends StatelessWidget {
  final Channel channel;
  final bool isFullscreen;
  final bool controlsVisible;
  final VoidCallback onTap;
  final VoidCallback onFullscreenToggle;
  final Widget? backButton;
  final Widget? topBar;

  const _PlayerContainer({
    required this.channel,
    required this.isFullscreen,
    required this.controlsVisible,
    required this.onTap,
    required this.onFullscreenToggle,
    this.backButton,
    this.topBar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isFullscreen ? double.infinity : 240,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Video player — isolated from overlay repaints
          RepaintBoundary(
            child: ChannelVideoPlayer.create(
              channel: channel,
              isFullscreen: isFullscreen,
              onFullscreenToggle: onFullscreenToggle,
              showControls: controlsVisible,
              onTap: onTap,
            ),
          ),

          // Back button overlay
          if (backButton != null)
            Positioned(
              top: 12,
              left: 12,
              child: IgnorePointer(
                ignoring: !controlsVisible,
                child: AnimatedOpacity(
                  opacity: controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: backButton!,
                ),
              ),
            ),

          // Fullscreen top bar overlay
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
    );
  }
}

/// Channel details card — extracted as StatelessWidget for const optimization.
class _ChannelDetailsCard extends StatelessWidget {
  final Channel channel;
  const _ChannelDetailsCard({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GoPlayTheme.cardBorder, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChannelAvatar(name: channel.name, logo: channel.logo, isLive: channel.isLive, size: 48),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    if (channel.isLive) ...[const SizedBox(width: 8), const LiveBadge()],
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (channel.quality != null)
                      _Badge(text: channel.quality!, bg: GoPlayTheme.primary.withAlpha(25), fg: GoPlayTheme.primary),
                    if (channel.category != null && channel.category!.isNotEmpty)
                      _Badge(text: channel.category!.toUpperCase(), bg: GoPlayTheme.surfaceContainerHighest, fg: GoPlayTheme.onSurfaceVariant),
                    if (channel.country != null && channel.country!.isNotEmpty)
                      _Badge(text: channel.country!, bg: GoPlayTheme.surfaceContainerHighest, fg: GoPlayTheme.onSurfaceVariant),
                    if (channel.hasDrm)
                      _Badge(text: 'DRM', bg: Colors.orange.withAlpha(30), fg: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withAlpha(30), width: 0.5),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text,
        style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
      ),
    );
  }
}

class _ChannelAvatar extends StatelessWidget {
  final String name;
  final String? logo;
  final bool isLive;
  final double size;
  const _ChannelAvatar({required this.name, this.logo, this.isLive = false, this.size = 42});

  @override
  Widget build(BuildContext context) {
    final initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: isLive ? GoPlayTheme.primary.withAlpha(60) : GoPlayTheme.cardBorder,
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: logo != null && logo!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: logo!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (_, __) => Center(child: Text(initials, style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: size * 0.28, fontWeight: FontWeight.w800))),
                errorWidget: (_, __, ___) => Center(child: Text(initials, style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: size * 0.28, fontWeight: FontWeight.w800))),
              )
            : Center(child: Text(initials, style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: size * 0.28, fontWeight: FontWeight.w800))),
      ),
    );
  }
}

class _RelatedChannelsList extends ConsumerWidget {
  final String category;
  final String currentChannelId;
  final bool isDesktopLayout;
  final Function(String) onChannelSelected;

  const _RelatedChannelsList({
    required this.category,
    required this.currentChannelId,
    required this.isDesktopLayout,
    required this.onChannelSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsAsync = ref.watch(channelsProvider);

    return channelsAsync.when(
      data: (channels) {
        final related = channels.where((c) => c.category == category).toList();

        if (related.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No other channels in this category', style: TextStyle(color: GoPlayTheme.onSurfaceVariant, fontSize: 13)),
            ),
          );
        }

        if (isDesktopLayout) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: related.length,
            itemBuilder: (context, index) {
              final ch = related[index];
              return _SwitcherTile(
                channel: ch,
                isCurrent: ch.id == currentChannelId,
                onTap: () => onChannelSelected(ch.id),
              );
            },
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: related.map((ch) {
              return _SwitcherTile(
                channel: ch,
                isCurrent: ch.id == currentChannelId,
                onTap: () => onChannelSelected(ch.id),
              );
            }).toList(),
          );
        }
      },
      loading: () => const Center(
        child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: GoPlayTheme.primary)),
      ),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

/// Switcher tile — now a standalone StatelessWidget with no AnimatedContainer
/// to avoid triggering layout/paint on unrelated state changes.
class _SwitcherTile extends StatelessWidget {
  final Channel channel;
  final bool isCurrent;
  final VoidCallback onTap;

  const _SwitcherTile({required this.channel, required this.isCurrent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent ? GoPlayTheme.primary.withAlpha(15) : GoPlayTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? GoPlayTheme.primary.withAlpha(60) : GoPlayTheme.cardBorder,
          width: isCurrent ? 1.0 : 0.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: _ChannelAvatar(
          name: channel.name,
          logo: channel.logo,
          isLive: isCurrent,
          size: 42,
        ),
        title: Row(
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
            if (isCurrent) ...[const SizedBox(width: 8), const _PlayingEqualizer()],
          ],
        ),
        subtitle: Row(
          children: [
            if (channel.quality != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isCurrent ? GoPlayTheme.primary.withAlpha(25) : GoPlayTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  channel.quality!,
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
                '${channel.category ?? ''} • ${channel.country ?? ''}',
                style: TextStyle(
                  color: isCurrent ? GoPlayTheme.primary.withAlpha(150) : GoPlayTheme.onSurfaceVariant,
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
                  style: TextStyle(color: GoPlayTheme.primary, fontSize: 8.5, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              )
            : (channel.isLive
                ? Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(color: GoPlayTheme.liveBadge, shape: BoxShape.circle),
                  )
                : null),
        onTap: isCurrent ? null : onTap,
      ),
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
              GestureDetector(
                onTap: onBackPressed,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: channelsAsync.when(
                  data: (channels) {
                    final related = channels.where((c) => c.category == category).toList();
                    if (related.isEmpty) return const SizedBox.shrink();

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

  const _ServerPill({required this.channel, required this.isCurrent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: GestureDetector(
        onTap: isCurrent ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCurrent ? GoPlayTheme.primary : Colors.white.withAlpha(80),
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
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (index) {
              final phase = index * (2 / 3 * math.pi);
              final multiplier = (0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi + phase)).abs();
              return Container(
                width: 2.5,
                height: 2 + 8 * multiplier,
                decoration: BoxDecoration(
                  color: GoPlayTheme.primary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
