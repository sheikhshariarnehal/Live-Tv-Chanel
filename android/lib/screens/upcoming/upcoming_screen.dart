import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../widgets/cards/event_card.dart';
import '../../widgets/app_overflow_menu.dart';

final groupedUpcomingEventsProvider = Provider.autoDispose<AsyncValue<Map<String, List<SportEvent>>>>((ref) {
  final eventsAsync = ref.watch(upcomingEventsProvider);
  return eventsAsync.whenData(UpcomingScreen._groupByDate);
});

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedUpcomingEventsProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            toolbarHeight: kToolbarHeight,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            title: const Text(
              'Upcoming',
              style: TextStyle(
                fontFamily: GoPlayType.family,
                color: GoPlayTheme.onSurface,
                fontSize: GoPlayType.xl,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            actions: const [
              AppOverflowMenu(iconColor: Colors.white),
              SizedBox(width: 8),
            ],
          ),

              groupedAsync.when(
                data: (grouped) {
                  if (grouped.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    );
                  }

                  final keys = grouped.keys.toList(growable: false);

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final key = keys[index];
                      final dayEvents = grouped[key]!;
                      return _DateGroup(
                        label: key,
                        events: dayEvents,
                        onEventTap: (event) {
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
                                content: Text(
                                  'No channels available for this event.',
                                ),
                                backgroundColor: GoPlayTheme.error,
                              ),
                            );
                          }
                        },
                      );
                    }, childCount: grouped.length),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: GoPlayTheme.primary,
                    ),
                  ),
                ),
                error: (e, _) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error: $e',
                      style: const TextStyle(color: GoPlayTheme.error),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        );
      }

  static Map<String, List<SportEvent>> _groupByDate(List<SportEvent> events) {
    final Map<String, List<SportEvent>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    for (final event in events) {
      final localStart = event.startTime.toLocal();
      final eventDate = DateTime(
        localStart.year,
        localStart.month,
        localStart.day,
      );

      final String label;
      if (eventDate == today) {
        label = 'Today';
      } else if (eventDate == tomorrow) {
        label = 'Tomorrow';
      } else if (eventDate.isBefore(nextWeek)) {
        label = DateFormat('EEEE, MMM d').format(localStart);
      } else {
        label = DateFormat('MMM d, yyyy').format(localStart);
      }

      grouped.putIfAbsent(label, () => []).add(event);
    }

    return grouped;
  }
}

// ─── Extracted sub-widgets ───────────────────────────────────────────────────
// Extracting to their own classes lets Flutter's element tree skip rebuilding
// them when their inputs haven't changed.

class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.label,
    required this.events,
    required this.onEventTap,
  });

  final String label;
  final List<SportEvent> events;
  final void Function(SportEvent) onEventTap;

  @override
  Widget build(BuildContext context) {
    final isDesktopOrTv = MediaQuery.of(context).size.width >= 800;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: GoPlayTheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoPlayType.label.copyWith(
                    color: GoPlayTheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Event tiles — 3 per row on TV/Desktop, 1 per row on mobile
          if (isDesktopOrTv)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: EventCard.tileExtent(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 0,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => onEventTap(event),
                );
              },
            )
          else
            ...events.map(
              (event) => EventCard(
                key: ValueKey(event.id),
                event: event,
                onTap: () => onEventTap(event),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: GoPlayTheme.cardGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GoPlayTheme.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0x0A71768E), // Alabaster Grey @ 4%
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.event_outlined,
                      size: 40,
                      color: GoPlayTheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'No Upcoming Events',
                  style: TextStyle(
                    fontFamily: GoPlayType.family,
                    color: GoPlayTheme.onSurface,
                    fontSize: GoPlayType.lg,
                    fontWeight: FontWeight.w700,
                    height: GoPlayType.leadingTitle,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for scheduled live streams.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoPlayType.family,
                    color: GoPlayTheme.onSurfaceVariant,
                    fontSize: GoPlayType.base,
                    fontWeight: FontWeight.w400,
                    height: GoPlayType.leadingBody,
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
