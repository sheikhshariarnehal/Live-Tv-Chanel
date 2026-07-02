import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';

import '../../widgets/cards/event_list_tile.dart';
import '../../widgets/cards/match_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';
import '../../widgets/team_flag.dart';
import '../../widgets/channel_selector.dart';
import '../../widgets/countdown_timer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            title: Text(
              'GOPLAY',
              style: GoogleFonts.orbitron(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: GoPlayTheme.primary,
                letterSpacing: 3,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () => context.push('/search'),
              ),
            ],
          ),

          // Hero Banner
          SliverToBoxAdapter(child: _HeroBanner()),

          // Live/Ongoing Matches
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Matches',
              icon: Icons.sports_soccer_rounded,
            ),
          ),
          SliverToBoxAdapter(child: _MatchTabs()),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: _MatchesSection()),

          // Today's Schedule
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Schedule",
              icon: Icons.calendar_today_rounded,
              actionLabel: 'See All',
              onAction: () => context.go('/upcoming'),
            ),
          ),
          SliverToBoxAdapter(child: _TodaySchedule()),

          // Trending Channels
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Channels',
              icon: Icons.trending_up_rounded,
              actionLabel: 'All Channels',
              onAction: () => context.go('/channels'),
            ),
          ),
          SliverToBoxAdapter(child: _TrendingChannels()),

          // Recently Watched
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: _RecentlyWatched()),

          // Announcements
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: _AnnouncementsSection()),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Hero Banner ──────────────────────────────────────────────
class _HeroBanner extends ConsumerStatefulWidget {
  @override
  ConsumerState<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<_HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
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
                  setState(() => _currentPage = index);
                },
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GestureDetector(
                    onTap: () {
                      if (event.channels.isNotEmpty) {
                        context.push('/player/${event.channels.first}');
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: event.banner != null && event.banner!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(event.banner!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        border: Border.all(
                          color: Colors.white.withAlpha(20),
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                children: [
                                  // Top Row: League and Status Badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        event.league,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (event.isLive)
                                        const LiveBadge(fontSize: 11)
                                      else
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: GoPlayTheme.primary.withAlpha(30),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: GoPlayTheme.primary.withAlpha(80),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 5,
                                                decoration: const BoxDecoration(
                                                  color: GoPlayTheme.primary,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                'UPCOMING',
                                                style: GoogleFonts.inter(
                                                  color: GoPlayTheme.primary,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
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
                                            Text(
                                              'VS',
                                              style: GoogleFonts.orbitron(
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
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'STARTS IN',
                                              style: GoogleFonts.inter(
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
                                              ),
                                            ),
                                            if (event.isLive)
                                              Text(
                                                'LIVE NOW',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withAlpha(160),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              CountdownTimerWidget(
                                                startTime: event.startTime,
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w800,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withAlpha(160),
                                                      blurRadius: 2,
                                                    ),
                                                  ],
                                                ),
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
                                    child: Container(
                                      width: 150,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: GoPlayTheme.primary,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: GoPlayTheme.primary.withAlpha(40),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        event.isLive ? 'WATCH LIVE' : 'MATCH HUB',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF003300),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
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
                  );
                },
              ),
            ),
            if (events.length > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  events.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _currentPage == index
                          ? GoPlayTheme.primary
                          : GoPlayTheme.primary.withAlpha(80),
                    ),
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? GoPlayTheme.primary.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? GoPlayTheme.primary : GoPlayTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Matches Section ──────────────────────────────────────────
class _MatchesSection extends ConsumerWidget {
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
            itemBuilder: (context, index) {
              final event = events[index];
              return MatchCard(
                event: event,
                onTap: () => showChannelSelector(
                  context: context,
                  ref: ref,
                  event: event,
                ),
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: todayEvents.map((event) => EventListTile(
                  event: event,
                  onTap: () => showChannelSelector(
                    context: context,
                    ref: ref,
                    event: event,
                  ),
                )).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─── Trending Channels ────────────────────────────────────────
class _TrendingChannels extends ConsumerWidget {
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
            itemBuilder: (context, index) {
              final ch = channels[index];
              return GestureDetector(
                onTap: () => context.push('/player/${ch.id}'),
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: GoPlayTheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ch.isLive
                                ? GoPlayTheme.primary.withAlpha(80)
                                : GoPlayTheme.cardBorder,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: ch.logo != null && ch.logo!.isNotEmpty
                              ? Image.network(
                                  ch.logo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Text(
                                      ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                                      style: TextStyle(
                                        color: GoPlayTheme.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                                    style: TextStyle(
                                      color: GoPlayTheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ch.name,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(watchHistoryProvider);

    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SectionHeader(
          title: 'Recently Watched',
          icon: Icons.history_rounded,
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final ch = history[index];
              return GestureDetector(
                onTap: () => context.push('/player/${ch.id}'),
                child: Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: GoPlayTheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            ch.name.substring(0, ch.name.length >= 2 ? 2 : 1).toUpperCase(),
                            style: TextStyle(
                              color: GoPlayTheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return announcementsAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            const SectionHeader(
              title: 'Announcements',
              icon: Icons.campaign_rounded,
            ),
            ...announcements.map((a) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: a.type == 'warning'
                        ? const Color(0xFF3D3300).withAlpha(60)
                        : GoPlayTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: a.type == 'warning'
                          ? Colors.amber.withAlpha(40)
                          : GoPlayTheme.cardBorder,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        a.type == 'warning'
                            ? Icons.warning_amber_rounded
                            : Icons.info_outline_rounded,
                        color: a.type == 'warning'
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
                )),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: TeamFlagWidget(flag: flag, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            teamName,
            style: GoogleFonts.inter(
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
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


