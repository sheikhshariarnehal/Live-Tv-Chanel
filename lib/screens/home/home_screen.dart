import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';

import '../../widgets/cards/event_list_tile.dart';
import '../../widgets/section_header.dart';
import '../../widgets/live_badge.dart';

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
class _HeroBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredEventsProvider);

    return featuredAsync.when(
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();
        final event = events.first;
        return GestureDetector(
          onTap: () {
            if (event.channels.isNotEmpty) {
              context.push('/player/${event.channels.first}');
            }
          },
          child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1B3D2F),
                  Color(0xFF0D1B14),
                  Color(0xFF0D0D0D),
                ],
              ),
              border: Border.all(
                color: GoPlayTheme.primary.withAlpha(30),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Stadium overlay
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topCenter,
                          radius: 1.5,
                          colors: [
                            GoPlayTheme.primary.withAlpha(15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Status badge
                      Row(
                        children: [
                          if (event.isLive)
                            const LiveBadge(fontSize: 11)
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: GoPlayTheme.primary.withAlpha(30),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '● UPCOMING',
                                style: TextStyle(
                                  color: GoPlayTheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Event title
                      Text(
                        event.league,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: GoPlayTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Teams
                      Row(
                        children: [
                          Text(
                            '${event.homeTeam.flag ?? ''} ${event.homeTeam.name}',
                            style: const TextStyle(
                              color: GoPlayTheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            '  vs  ',
                            style: TextStyle(
                              color: GoPlayTheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${event.awayTeam.name} ${event.awayTeam.flag ?? ''}',
                            style: const TextStyle(
                              color: GoPlayTheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),

                          // Watch button
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: GoPlayTheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'WATCH',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF003300),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: events.map((event) {
              return EventListTile(
                event: event,
                onTap: () {
                  if (event.channels.isNotEmpty) {
                    context.push('/player/${event.channels.first}');
                  }
                },
              );
            }).toList(),
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
          return e.startTime.year == now.year &&
              e.startTime.month == now.month &&
              e.startTime.day == now.day;
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

        // Group by sport
        final Map<String, List<SportEvent>> grouped = {};
        for (final e in todayEvents) {
          grouped.putIfAbsent(e.sport, () => []).add(e);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, top: 4),
                    child: Text(
                      '${_sportIcon(entry.key)} ${entry.key}',
                      style: const TextStyle(
                        color: GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...entry.value.map((event) => EventListTile(
                        event: event,
                        onTap: () {
                          if (event.channels.isNotEmpty) {
                            context.push('/player/${event.channels.first}');
                          }
                        },
                      )),
                ],
              );
            }).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _sportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'football':
        return '⚽';
      case 'cricket':
        return '🏏';
      case 'basketball':
        return '🏀';
      case 'tennis':
        return '🎾';
      default:
        return '🏆';
    }
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
                            ch.name.substring(0, 2).toUpperCase(),
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
