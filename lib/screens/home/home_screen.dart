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
// Avoids recreating GoogleFonts TextStyle objects on every frame.
final TextStyle _orbitronTitle = GoogleFonts.orbitron(
  fontSize: 22,
  fontWeight: FontWeight.w900,
  color: GoPlayTheme.primary,
  letterSpacing: 3,
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
  shadows: [
    Shadow(
      color: Colors.black.withAlpha(160),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ],
);

final TextStyle _interStartsIn = GoogleFonts.inter(
  color: Colors.white.withAlpha(160),
  fontSize: 7.5,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
  shadows: [
    Shadow(
      color: Colors.black.withAlpha(160),
      blurRadius: 2,
    ),
  ],
);

final TextStyle _interLiveNow = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w800,
  shadows: [
    Shadow(
      color: Colors.black.withAlpha(160),
      blurRadius: 2,
    ),
  ],
);

final TextStyle _interCountdown = GoogleFonts.inter(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w800,
  shadows: [
    Shadow(
      color: Colors.black.withAlpha(160),
      blurRadius: 2,
    ),
  ],
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
  shadows: [
    Shadow(
      color: Colors.black.withAlpha(180),
      blurRadius: 4,
      offset: const Offset(0, 1),
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
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: false,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {},
            ),
            title: Text('GOPLAY', style: _orbitronTitle),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => context.push('/search'),
              ),
            ],
          ),

          // Hero Banner
          const SliverToBoxAdapter(child: RepaintBoundary(child: _HeroBanner())),

          // Trending Channels
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Channels',
              actionLabel: 'All Channels',
              onAction: () => context.go('/channels'),
            ),
          ),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _TrendingChannels())),

          // Live/Ongoing Matches
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Matches',
            ),
          ),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _MatchTabs())),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _MatchesSection())),

          // Today's Schedule
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Schedule",
              actionLabel: 'See All',
              onAction: () => context.go('/upcoming'),
            ),
          ),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _TodaySchedule())),

          // Recently Watched
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _RecentlyWatched())),

          // Announcements
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(child: RepaintBoundary(child: _AnnouncementsSection())),

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
                              : GoPlayTheme.primary.withAlpha(80),
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
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Individual hero banner card — extracted to its own widget to avoid
/// rebuilding all cards when the page indicator changes.
class _HeroBannerCard extends ConsumerWidget {
  final SportEvent event;
  const _HeroBannerCard({required this.event});

  // Cache static decoration objects
  static final _cardRadius = BorderRadius.circular(24);
  static final _cardDecoration = BoxDecoration(
    borderRadius: _cardRadius,
    border: Border.all(color: Colors.white.withAlpha(20), width: 1.0),
  );
  static final _upcomingBadgeDecoration = BoxDecoration(
    color: GoPlayTheme.primary.withAlpha(30),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: GoPlayTheme.primary.withAlpha(80), width: 0.5),
  );
  static final _watchButtonDecoration = BoxDecoration(
    color: GoPlayTheme.primary,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: GoPlayTheme.primary.withAlpha(40),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
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
                    placeholder: (_, __) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                    errorWidget: (_, __, ___) => const ColoredBox(
                      color: GoPlayTheme.surfaceContainerHigh,
                    ),
                  ),
              // Content overlay
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 5,
                                    height: 5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: GoPlayTheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text('UPCOMING', style: _interUpcomingBadge),
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
                        _TeamCard(teamName: event.homeTeam.name, flag: event.homeTeam.flag),
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
                        _TeamCard(teamName: event.awayTeam.name, flag: event.awayTeam.flag),
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

// ─── Match Tabs ────────────────────────────────────────────────
final _matchTabProvider = NotifierProvider<_MatchTabNotifier, int>(
  _MatchTabNotifier.new,
);

class _MatchTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int tab) => state = tab;
}

class _MatchTabs extends ConsumerWidget {
  const _MatchTabs();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(_matchTabProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TabButton(
            label: 'LIVE',
            isSelected: tab == 0,
            onTap: () => ref.read(_matchTabProvider.notifier).select(0),
          ),
          const SizedBox(width: 8),
          _TabButton(
            label: 'UPCOMING',
            isSelected: tab == 1,
            onTap: () => ref.read(_matchTabProvider.notifier).select(1),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static final _selectedDecoration = BoxDecoration(
    color: GoPlayTheme.primary.withAlpha(25),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: GoPlayTheme.primary, width: 1),
  );
  static final _unselectedDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: GoPlayTheme.cardBorder, width: 1),
  );
  static const _selectedTextStyle = TextStyle(
    color: GoPlayTheme.primary,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
  static const _unselectedTextStyle = TextStyle(
    color: GoPlayTheme.onSurfaceVariant,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected ? _selectedDecoration : _unselectedDecoration,
        child: Text(
          label,
          style: isSelected ? _selectedTextStyle : _unselectedTextStyle,
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
    final tab = ref.watch(_matchTabProvider);
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (allEvents) {
        final events = tab == 0
            ? allEvents.where((e) => e.isLive).toList()
            : allEvents.where((e) => e.isUpcoming).toList();

        if (events.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    tab == 0 ? Icons.live_tv_outlined : Icons.schedule_outlined,
                    color: GoPlayTheme.onSurfaceVariant,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tab == 0 ? 'No live matches right now' : 'No upcoming matches',
                    style: const TextStyle(color: GoPlayTheme.onSurfaceVariant),
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
        child: Center(child: CircularProgressIndicator(color: GoPlayTheme.primary)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $e', style: const TextStyle(color: GoPlayTheme.error)),
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

        // Use ListView.builder for lazy rendering instead of Column + .map()
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
      error: (_, __) => const SizedBox.shrink(),
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
      error: (_, __) => const SizedBox.shrink(),
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
        const SectionHeader(
          title: 'Recently Watched',
        ),
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

  static final _warningDecoration = BoxDecoration(
    color: const Color(0xFF3D3300).withAlpha(60),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.amber.withAlpha(40), width: 0.5),
  );

  static final _infoDecoration = BoxDecoration(
    color: GoPlayTheme.surfaceContainer,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: GoPlayTheme.cardBorder, width: 0.5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DecoratedBox(
                    decoration: isWarning ? _warningDecoration : _infoDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            isWarning
                                ? Icons.warning_amber_rounded
                                : Icons.info_outline_rounded,
                            color: isWarning ? Colors.amber : GoPlayTheme.primary,
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
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String teamName;
  final String? flag;

  const _TeamCard({
    required this.teamName,
    required this.flag,
  });

  // Cache decoration to avoid recreating Border + BoxShadow objects per frame
  static final _avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.white, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(60),
        blurRadius: 6,
        offset: const Offset(0, 2),
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
              child: ClipOval(
                child: TeamFlagWidget(flag: flag, size: 40),
              ),
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

