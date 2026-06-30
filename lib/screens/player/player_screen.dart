import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/channel.dart';
import '../../widgets/live_badge.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String channelId;
  const PlayerScreen({super.key, required this.channelId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _isFullscreen = false;
  bool _controlsVisible = true;
  bool _isFavorite = false;
  late String _currentChannelId;

  @override
  void initState() {
    super.initState();
    _currentChannelId = widget.channelId;
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channelAsync = ref.watch(channelProvider(_currentChannelId));
    final favorites = ref.watch(favoriteChannelIdsProvider);
    final channelsAsync = ref.watch(channelsProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
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

          _isFavorite = favorites.contains(channel.id);

          if (isDesktop && !_isFullscreen) {
            return Row(
              children: [
                // Left side: Video player
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _controlsVisible = !_controlsVisible);
                      if (_controlsVisible) _hideControlsAfterDelay();
                    },
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: GoPlayTheme.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 56,
                                    color: GoPlayTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  channel.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  channel.streamUrl,
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(120),
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (_controlsVisible)
                            _PlayerControls(
                              channel: channel,
                              isFullscreen: false,
                              isFavorite: _isFavorite,
                              onBack: () => Navigator.of(context).pop(),
                              onFullscreen: _toggleFullscreen,
                              onFavoriteToggle: () {
                                ref
                                    .read(favoriteChannelIdsProvider.notifier)
                                    .toggle(channel.id);
                              },
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
                  width: 340,
                  child: Container(
                    color: GoPlayTheme.surface,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: GoPlayTheme.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      channel.name.substring(0, 2).toUpperCase(),
                                      style: TextStyle(
                                        color: GoPlayTheme.primary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
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
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          if (channel.quality != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color:
                                                    GoPlayTheme.primary.withAlpha(25),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                channel.quality!,
                                                style: TextStyle(
                                                  color: GoPlayTheme.primary,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${channel.category ?? ''} • ${channel.country ?? ''}',
                                        style: const TextStyle(
                                          color: GoPlayTheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const LiveBadge(),
                              ],
                            ),
                          ),
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
                            child: channelsAsync.when(
                              data: (channels) {
                                final related = channels
                                    .where((c) =>
                                        c.id != channel.id &&
                                        c.category == channel.category)
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

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: related.length,
                                  itemBuilder: (context, index) {
                                    final ch = related[index];
                                    return ListTile(
                                      leading: Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: GoPlayTheme.surfaceContainerHigh,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            ch.name.substring(0, 2).toUpperCase(),
                                            style: TextStyle(
                                              color: GoPlayTheme.primary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        ch.name,
                                        style: const TextStyle(
                                          color: GoPlayTheme.onSurface,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${ch.quality ?? 'SD'} • ${ch.country ?? ''}',
                                        style: const TextStyle(
                                          color: GoPlayTheme.onSurfaceVariant,
                                          fontSize: 11,
                                        ),
                                      ),
                                      trailing: ch.isLive
                                          ? Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: GoPlayTheme.liveBadge,
                                                shape: BoxShape.circle,
                                              ),
                                            )
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          _currentChannelId = ch.id;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: GoPlayTheme.primary),
                              ),
                              error: (_, __) => const SizedBox.shrink(),
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

          return Column(
            children: [
              // Video Player Area
              Expanded(
                flex: _isFullscreen ? 1 : 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _controlsVisible = !_controlsVisible);
                    if (_controlsVisible) _hideControlsAfterDelay();
                  },
                  child: Container(
                    height: _isFullscreen ? double.infinity : 240,
                    width: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        // Placeholder for video (simulated)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: GoPlayTheme.surfaceContainerHigh,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 48,
                                  color: GoPlayTheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                channel.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                channel.streamUrl,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(100),
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Controls overlay
                        if (_controlsVisible)
                          _PlayerControls(
                            channel: channel,
                            isFullscreen: _isFullscreen,
                            isFavorite: _isFavorite,
                            onBack: () => Navigator.of(context).pop(),
                            onFullscreen: _toggleFullscreen,
                            onFavoriteToggle: () {
                              ref
                                  .read(favoriteChannelIdsProvider.notifier)
                                  .toggle(channel.id);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Channel info + related channels (portrait only)
              if (!_isFullscreen)
                Expanded(
                  child: Container(
                    color: GoPlayTheme.surface,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Current channel info
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: GoPlayTheme.surfaceContainerHigh,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    channel.name.substring(0, 2).toUpperCase(),
                                    style: TextStyle(
                                      color: GoPlayTheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          channel.name,
                                          style: const TextStyle(
                                            color: GoPlayTheme.onSurface,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (channel.quality != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color:
                                                  GoPlayTheme.primary.withAlpha(25),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              channel.quality!,
                                              style: TextStyle(
                                                color: GoPlayTheme.primary,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      '${channel.category ?? ''} • ${channel.country ?? ''}',
                                      style: const TextStyle(
                                        color: GoPlayTheme.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const LiveBadge(),
                            ],
                          ),
                        ),

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

                        // Related channels list
                        channelsAsync.when(
                          data: (channels) {
                            final related = channels
                                .where((c) =>
                                    c.id != channel.id &&
                                    c.category == channel.category)
                                .toList();

                            return Column(
                              children: related.map((ch) {
                                return ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: GoPlayTheme.surfaceContainerHigh,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        ch.name.substring(0, 2).toUpperCase(),
                                        style: TextStyle(
                                          color: GoPlayTheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    ch.name,
                                    style: const TextStyle(
                                      color: GoPlayTheme.onSurface,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${ch.quality ?? 'SD'} • ${ch.country ?? ''}',
                                    style: const TextStyle(
                                      color: GoPlayTheme.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                  trailing: ch.isLive
                                      ? Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: GoPlayTheme.liveBadge,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    setState(() {
                                      _currentChannelId = ch.id;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
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
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: GoPlayTheme.error)),
        ),
      ),
    );
  }
}

class _PlayerControls extends StatelessWidget {
  final Channel channel;
  final bool isFullscreen;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFullscreen;
  final VoidCallback onFavoriteToggle;

  const _PlayerControls({
    required this.channel,
    required this.isFullscreen,
    required this.isFavorite,
    required this.onBack,
    required this.onFullscreen,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withAlpha(150),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withAlpha(150),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      channel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_outline,
                      color: isFavorite ? GoPlayTheme.liveBadge : Colors.white,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Quality
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    channel.quality ?? 'HD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Fullscreen
                IconButton(
                  icon: Icon(
                    isFullscreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  onPressed: onFullscreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
