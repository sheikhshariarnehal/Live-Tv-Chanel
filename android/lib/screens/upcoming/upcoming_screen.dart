import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/app_providers.dart';
import '../../models/event.dart';
import '../../widgets/cards/event_list_tile.dart';

final groupedUpcomingEventsProvider = Provider.autoDispose<AsyncValue<Map<String, List<SportEvent>>>>((ref) {
  final eventsAsync = ref.watch(upcomingEventsProvider);
  return eventsAsync.whenData(UpcomingScreen._groupByDate);
});

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(groupedUpcomingEventsProvider);

    return Material(
      color: GoPlayTheme.surface,
      child: Stack(
        children: [
          // Solid background — cheapest possible widget.
          const ColoredBox(
            color: GoPlayTheme.surface,
            child: SizedBox.expand(),
          ),

          // Scroll content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 110.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const SizedBox.shrink(),
                leadingWidth: 0,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final double statusBarHeight = MediaQuery.of(
                      context,
                    ).padding.top;
                    final double minHeight = kToolbarHeight + statusBarHeight;
                    final double maxHeight = 110.0 + statusBarHeight;

                    // Calculate collapse ratio: 0.0 (fully expanded) to 1.0 (fully collapsed)
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
                              ((0.4 + (0.45 * collapseRatio)) * 255)
                                  .round()
                                  .clamp(0, 255),
                              0x17,
                              0x18,
                              0x1C,
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(
                                  ((0.15 * collapseRatio) * 255).round().clamp(
                                    0,
                                    255,
                                  ),
                                  0x71,
                                  0x76,
                                  0x8E,
                                ),
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: FlexibleSpaceBar(
                            centerTitle: true,
                            titlePadding: EdgeInsets.only(
                              left: 20 - (20 * collapseRatio),
                              bottom: 14 + (2 * collapseRatio),
                            ),
                            title: Align(
                              alignment: Alignment.lerp(
                                Alignment.bottomLeft,
                                Alignment.bottomCenter,
                                collapseRatio,
                              )!,
                              child: Text(
                                'Upcoming',
                                style: (Theme.of(context).appBarTheme.titleTextStyle ?? const TextStyle()).copyWith(
                                  color: Colors.white,
                                  fontSize: 26 - (6 * collapseRatio),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
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
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Event tiles — 3 per row on TV/Desktop, 1 per row on mobile
          if (isDesktopOrTv)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 110,
                crossAxisSpacing: 12,
                mainAxisSpacing: 0,
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventListTile(
                  key: ValueKey(event.id),
                  event: event,
                  onTap: () => onEventTap(event),
                );
              },
            )
          else
            ...events.map(
              (event) => EventListTile(
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for scheduled live streams.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x80FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
