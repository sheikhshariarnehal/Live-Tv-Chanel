import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../widgets/cards/event_list_tile.dart';
import '../../widgets/channel_selector.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: false,
            leading: SizedBox.shrink(),
            leadingWidth: 0,
            title: Text('Upcoming'),
          ),

          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_outlined,
                            size: 60, color: GoPlayTheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          'No upcoming events',
                          style: TextStyle(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Group events by date
              final grouped = _groupByDate(events);

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = grouped.entries.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Date header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: GoPlayTheme.primary.withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                color: GoPlayTheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Events for this date
                          ...entry.value.map((event) => EventListTile(
                                event: event,
                                onTap: () => showChannelSelector(
                                  context: context,
                                  ref: ref,
                                  event: event,
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                  childCount: grouped.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: GoPlayTheme.primary),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $e',
                    style: const TextStyle(color: GoPlayTheme.error)),
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Map<String, List<SportEvent>> _groupByDate(List<SportEvent> events) {
    final Map<String, List<SportEvent>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    for (final event in events) {
      final localStart = event.startTime.toLocal();
      final eventDate =
          DateTime(localStart.year, localStart.month, localStart.day);

      String label;
      if (eventDate == today) {
        label = '📅 Today';
      } else if (eventDate == tomorrow) {
        label = '📅 Tomorrow';
      } else if (eventDate.isBefore(nextWeek)) {
        label = '📅 ${DateFormat('EEEE, MMM d').format(localStart)}';
      } else {
        label = '📅 ${DateFormat('MMM d, yyyy').format(localStart)}';
      }

      grouped.putIfAbsent(label, () => []).add(event);
    }

    return grouped;
  }
}
