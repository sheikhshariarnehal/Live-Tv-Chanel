import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';

import '../../widgets/cards/event_list_tile.dart';
import '../../widgets/cards/match_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/team_flag.dart';
import '../../widgets/channel_avatar.dart';
import '../../widgets/countdown_timer.dart';

// ─── Cached Text Styles ──────────────────────────────────────
final TextStyle _orbitronTitleBase = GoogleFonts.orbitron(
  fontWeight: FontWeight.w900,
  color: GoPlayTheme.primary,
);

final TextStyle _interLeagueBold = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

final TextStyle _interUpcomingBadge = GoogleFonts.inter(
  color: GoPlayTheme.primary,
  fontSize: 9,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

final TextStyle _orbitronVS = GoogleFonts.orbitron(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w900,
  letterSpacing: 1,
  shadows: const [
    Shadow(
      color: Color(0xA0000000), // black @ ~63%
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
);

final TextStyle _interStartsIn = GoogleFonts.inter(
  color: const Color(0xA0FFFFFF), // white @ ~63%
  fontSize: 7.5,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
  shadows: const [Shadow(color: Color(0xA0000000), blurRadius: 2)],
);

final TextStyle _interLiveNow = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w800,
  shadows: const [Shadow(color: Color(0xA0000000), blurRadius: 2)],
);

final TextStyle _interCountdown = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w800,
  shadows: const [Shadow(color: Color(0xA0000000), blurRadius: 2)],
);

final TextStyle _interButtonLabel = GoogleFonts.inter(
  color: const Color(0xFF003300),
  fontSize: 11,
  fontWeight: FontWeight.w900,
  letterSpacing: 0.5,
);

final TextStyle _interTeamName = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 11,
  fontWeight: FontWeight.w700,
  shadows: const [
    Shadow(
      color: Color(0xB4000000), // black @ ~70%
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off background sync now that Supabase is guaranteed ready.
    ref.watch(appSyncProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing Frosted Glass App Bar
          SliverAppBar(
            expandedHeight: 110.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                onPressed: () => context.push('/search'),
              ),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double appBarHeight = constraints.biggest.height;
                final double statusBarHeight = MediaQuery.of(
                  context,
                ).padding.top;
                final double minHeight = kToolbarHeight + statusBarHeight;
                final double maxHeight = 110.0 + statusBarHeight;

                final double collapseRatio =
                    ((maxHeight - appBarHeight) / (maxHeight - minHeight))
                        .clamp(0.0, 1.0);

                return ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 16 * collapseRatio,
                      sigmaY: 16 * collapseRatio,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          ((0.4 + (0.45 * collapseRatio)) * 255).round().clamp(
                            0,
                            255,
                          ),
                          0x0D,
                          0x0D,
                          0x12,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(
                              ((0.08 * collapseRatio) * 255).round().clamp(
                                0,
                                255,
                              ),
                              0xFF,
                              0xFF,
                              0xFF,
                            ),
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.only(
                          bottom: 14 + (2 * collapseRatio),
                        ),
                        title: Text(
                          'GOPLAY',
                          style: _orbitronTitleBase.copyWith(
                            fontSize: 22 - (3 * collapseRatio),
                            letterSpacing: 3 - (1.0 * collapseRatio),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Hero Banner
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _HeroBanner()),
          ),

          // Trending Channels
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Channels',
              actionLabel: 'All Channels',
              onAction: () => context.go('/channels'),
            ),
          ),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _TrendingChannels()),
          ),

          // Live/Ongoing Matches
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: SectionHeader(title: 'Live Matches')),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _MatchesSection()),
          ),

          // Today's Schedule
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Schedule",
              actionLabel: 'See All',
              onAction: () => context.go('/upcoming'),
            ),
          ),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _TodaySchedule()),
          ),

          // Recently Watched
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _RecentlyWatched()),
          ),

          // Announcements
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: RepaintBoundary(child: _AnnouncementsSection()),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Hero Banner ──────────────────────────────────────────────
class _HeroBanner extends ConsumerStatefulWidget {
  const _HeroBanner();

  @override
  ConsumerState<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<_HeroBanner> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredEventsProvider);

    return featuredAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _HeroBannerCard(event: event);
                },
              ),
            ),
            if (events.length > 1) ...[
              const SizedBox(height: 8),
              ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentPage, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      events.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: currentPage == index
                              ? GoPlayTheme.primary
                              : const Color(
                                  0x5000E676,
                                ), // GoPlayTheme.primary @ 31%
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
      loading: () => Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: GoPlayTheme.primary),
        ),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

/// Individual hero banner card
class _HeroBannerCard extends ConsumerWidget {
  final SportEvent event;
  const _HeroBannerCard({required this.event});

  static const _cardRadius = BorderRadius.all(Radius.circular(20));
  static const _cardDecoration = BoxDecoration(
    borderRadius: _cardRadius,
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8), // White @ 8%
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x1F000000), // Soft shadow
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static const _upcomingBadgeDecoration = BoxDecoration(
    color: Color(0x1E00E676), // GoPlayTheme.primary @ 12%
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(
        color: Color(0x5000E676),
        width: 0.5,
      ), // GoPlayTheme.primary @ 31%
    ),
  );

  static const _watchButtonDecoration = BoxDecoration(
    color: GoPlayTheme.primary,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow(
        color: Color(0x2800E676), // GoPlayTheme.primary @ 16%
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const _gradientOverlay = BoxDecoration(
    borderRadius: _cardRadius,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x20000000), // Transparent top
        Color(0x60000000), // Muted middle
        Color(0xD90D0D12), // Solid background bottom for contrast
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (event.channels.isNotEmpty) {
          context.push(
            '/player/${event.channels.first}',
            extra: {'eventChannels': event.channels, 'forceFullscreen': true},
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No channels available for this event.'),
              backgroundColor: GoPlayTheme.error,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
        child: DecoratedBox(
          decoration: _cardDecoration,
          child: ClipRRect(
            borderRadius: _cardRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cached banner image
                if (event.banner != null && event.banner!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: event.banner!,
                    fit: BoxFit.cover,
                    memCacheWidth: 800,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (context, url) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                    errorWidget: (context, url, error) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                  ),
                // Gradient dark overlay
                const DecoratedBox(decoration: _gradientOverlay),
                // Content overlay
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      // Top Row: League and Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(event.league, style: _interLeagueBold),
                          if (event.isLive)
                            const LiveBadge(fontSize: 11)
                          else
                            DecoratedBox(
                              decoration: _upcomingBadgeDecoration,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                      height: 5,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: GoPlayTheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'UPCOMING',
                                      style: _interUpcomingBadge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Spacer(),

                      // Middle Row: Matchup details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _TeamCard(
                            teamName: event.homeTeam.name,
                            flag: event.homeTeam.flag,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('VS', style: _orbitronVS),
                                const SizedBox(height: 6),
                                Text('STARTS IN', style: _interStartsIn),
                                if (event.isLive)
                                  Text('LIVE NOW', style: _interLiveNow)
                                else
                                  CountdownTimerWidget(
                                    startTime: event.startTime,
                                    onTimerFinished: () {
                                      ref.invalidate(eventsProvider);
                                    },
                                    style: _interCountdown,
                                  ),
                              ],
                            ),
                          ),
                          _TeamCard(
                            teamName: event.awayTeam.name,
                            flag: event.awayTeam.flag,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Spacer(),

                      // Bottom Row: Watch/Hub Button
                      Center(
                        child: DecoratedBox(
                          decoration: _watchButtonDecoration,
                          child: SizedBox(
                            width: 150,
                            height: 32,
                            child: Center(
                              child: Text(
                                event.isLive ? 'WATCH LIVE' : 'MATCH HUB',
                                style: _interButtonLabel,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ─── Matches Section ──────────────────────────────────────────
class _MatchesSection extends ConsumerWidget {
  const _MatchesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (allEvents) {
        final events = allEvents.where((e) => e.isLive).toList();

        if (events.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.live_tv_outlined,
                    color: GoPlayTheme.onSurfaceVariant,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No live matches right now',
                    style: TextStyle(color: GoPlayTheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: 125,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              final event = events[index];
              return MatchCard(
                event: event,
                onTap: () {
                  if (event.channels.isNotEmpty) {
                    context.push(
                      '/player/${event.channels.first}',
                      extra: {
                        'eventChannels': event.channels,
                        'forceFullscreen': true,
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No channels available for this event.'),
                        backgroundColor: GoPlayTheme.error,
                      ),
                    );
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(color: GoPlayTheme.primary),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: $e',
          style: const TextStyle(color: GoPlayTheme.error),
        ),
      ),
    );
  }
}

// ─── Today's Schedule ─────────────────────────────────────────
class _TodaySchedule extends ConsumerWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (events) {
        final now = DateTime.now();
        final todayEvents = events.where((e) {
          final localStart = e.startTime.toLocal();
          return localStart.year == now.year &&
              localStart.month == now.month &&
              localStart.day == now.day;
        }).toList();

        if (todayEvents.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'No events scheduled for today',
              style: TextStyle(color: GoPlayTheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: todayEvents.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemBuilder: (context, index) {
            final event = todayEvents[index];
            return EventListTile(
              event: event,
              onTap: () {
                if (event.channels.isNotEmpty) {
                  context.push(
                    '/player/${event.channels.first}',
                    extra: {
                      'eventChannels': event.channels,
                      'forceFullscreen': true,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No channels available for this event.'),
                      backgroundColor: GoPlayTheme.error,
                    ),
                  );
                }
              },
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

// ─── Trending Channels ────────────────────────────────────────
class _TrendingChannels extends ConsumerWidget {
  const _TrendingChannels();

  static const _nameStyle = TextStyle(
    color: GoPlayTheme.onSurface,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingChannelsProvider);

    return trendingAsync.when(
      data: (channels) {
        if (channels.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: channels.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              final ch = channels[index];
              return GestureDetector(
                onTap: () => context.push('/player/${ch.id}'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 75,
                    child: Column(
                      children: [
                        ChannelAvatar(channel: ch),
                        const SizedBox(height: 6),
                        Text(
                          ch.name,
                          style: _nameStyle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 90),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

// ─── Recently Watched ─────────────────────────────────────────
class _RecentlyWatched extends ConsumerWidget {
  const _RecentlyWatched();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(watchHistoryProvider);

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SectionHeader(title: 'Recently Watched'),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            addAutomaticKeepAlives: false,
            itemBuilder: (context, index) {
              final ch = history[index];
              return GestureDetector(
                onTap: () => context.push('/player/${ch.id}'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 75,
                    child: Column(
                      children: [
                        ChannelAvatar(channel: ch, showBorder: false),
                        const SizedBox(height: 6),
                        Text(
                          ch.name,
                          style: const TextStyle(
                            color: GoPlayTheme.onSurface,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Announcements ────────────────────────────────────────────
class _AnnouncementsSection extends ConsumerWidget {
  const _AnnouncementsSection();

  static const _warningDecoration = BoxDecoration(
    color: Color(0x14FFC107), // amber @ 8%
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x33FFC107), width: 0.8), // amber @ 20%
    ),
  );

  static const _infoDecoration = BoxDecoration(
    color: Color(0x0AFFFFFF), // white @ 4%
    borderRadius: BorderRadius.all(Radius.circular(16)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x14FFFFFF), width: 0.8), // white @ 8%
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return announcementsAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            const SectionHeader(title: 'Announcements'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: announcements.length,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemBuilder: (context, index) {
                final a = announcements[index];
                final isWarning = a.type == 'warning';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: DecoratedBox(
                    decoration: isWarning
                        ? _warningDecoration
                        : _infoDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            isWarning
                                ? Icons.warning_amber_rounded
                                : Icons.info_outline_rounded,
                            color: isWarning
                                ? Colors.amber
                                : GoPlayTheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.title,
                                  style: const TextStyle(
                                    color: GoPlayTheme.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  a.body,
                                  style: const TextStyle(
                                    color: GoPlayTheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String teamName;
  final String? flag;

  const _TeamCard({required this.teamName, required this.flag});

  static const _avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.fromBorderSide(
      BorderSide(color: Color(0x33FFFFFF), width: 1.5), // white @ 20%
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x3C000000), // black @ ~23%
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: _avatarDecoration,
            child: SizedBox(
              width: 48,
              height: 48,
              child: ClipOval(child: TeamFlagWidget(flag: flag, size: 40)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: _interTeamName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
