import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../../providers/app_providers.dart';
import '../live_badge.dart';
import '../team_flag.dart';
import '../countdown_timer.dart';
import '../tv_focus_wrapper.dart';

enum EventCardVariant {
  tile,    // Vertical list item (Exact match with Today's Schedule UI)
  compact, // Horizontal scrolling card (280px width)
}

// ─── Pre-computed static decorations ─────────────────────────────────────────
const _kLiveCardDecoration = BoxDecoration(
  color: GoPlayTheme.darkSurfaceContainer,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
  boxShadow: [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
);

const _kUpcomingCardDecoration = BoxDecoration(
  color: GoPlayTheme.darkSurfaceContainer,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
  boxShadow: [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
);

const _kLiveAccentDecoration = BoxDecoration(
  color: GoPlayTheme.liveBadge,
  borderRadius: BorderRadius.all(Radius.circular(2)),
);

const _kUpcomingAccentDecoration = BoxDecoration(
  color: GoPlayTheme.primary,
  borderRadius: BorderRadius.all(Radius.circular(2)),
);

const _kUpcomingBadgeDecoration = BoxDecoration(
  color: Color(0x0FFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
);

const _kCompactUpcomingBadgeDecoration = BoxDecoration(
  color: Color(0x0AFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(4)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
  ),
);

const _kCompactTimeBadgeDecoration = BoxDecoration(
  color: Color(0x0DFFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
  ),
);

const _kLeagueStyle = TextStyle(
  color: GoPlayTheme.onSurfaceVariant,
  fontSize: 10,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.0,
);

const _kBadgeStyle = TextStyle(
  color: Color(0x99FFFFFF),
  fontSize: 8,
  fontWeight: FontWeight.w800,
  letterSpacing: 0.5,
);

const _kTeamNameStyle = TextStyle(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w700,
  height: 1.1,
  letterSpacing: 0.0,
);

const _kCountdownStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 10,
  fontWeight: FontWeight.w800,
);

const _kTimeInfoStyle = TextStyle(
  color: GoPlayTheme.onSurfaceVariant,
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

const _kLiveTimeStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 18,
  fontWeight: FontWeight.w900,
  letterSpacing: -0.5,
);

const _kUpcomingTimeStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w900,
  letterSpacing: -0.5,
);

const _kMonths = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

/// Single consolidated, stateless EventCard component supporting both tile and compact variants.
class EventCard extends ConsumerWidget {
  final SportEvent event;
  final VoidCallback? onTap;
  final EventCardVariant variant;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.variant = EventCardVariant.tile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (variant == EventCardVariant.compact) {
      return _buildCompactCard(context, ref);
    }
    return _buildTileCard(context, ref);
  }

  /// Builds the vertical list tile card (1:1 matching screenshot)
  Widget _buildTileCard(BuildContext context, WidgetRef ref) {
    final isLive = event.isLive;
    final isToday = _checkIsToday(event.startTime);
    final timeLabel = _formatTime(event.startTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RepaintBoundary(
        child: TvFocusable(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: 96,
            child: DecoratedBox(
              decoration: isLive ? _kLiveCardDecoration : _kUpcomingCardDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4,
                              height: 12,
                              child: DecoratedBox(
                                decoration: isLive
                                    ? _kLiveAccentDecoration
                                    : _kUpcomingAccentDecoration,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                event.league.toUpperCase(),
                                style: _kLeagueStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isLive)
                        const LiveBadge(
                          fontSize: 8,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                        )
                      else
                        const DecoratedBox(
                          decoration: _kUpcomingBadgeDecoration,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: Text('UPCOMING', style: _kBadgeStyle),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Teams & Time row
                  Row(
                    children: [
                      // Home team
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TeamFlagWidget(flag: event.homeTeam.flag, size: 22),
                            const SizedBox(height: 2),
                            Text(
                              event.homeTeam.name,
                              style: _kTeamNameStyle,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Center: score / VS / time / countdown
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLive ? 'VS' : timeLabel,
                              style: isLive ? _kLiveTimeStyle : _kUpcomingTimeStyle,
                            ),
                            const SizedBox(height: 4),
                            if (event.isUpcoming && isToday)
                              CountdownTimerWidget(
                                startTime: event.startTime,
                                onTimerFinished: () {
                                  ref.read(syncServiceProvider).sync();
                                  ref.invalidate(eventsProvider);
                                },
                                style: _kCountdownStyle,
                              )
                            else if (!isLive)
                              Text(
                                _formatTimeInfo(event),
                                style: _kTimeInfoStyle,
                              ),
                          ],
                        ),
                      ),

                      // Away team
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TeamFlagWidget(flag: event.awayTeam.flag, size: 22),
                            const SizedBox(height: 2),
                            Text(
                              event.awayTeam.name,
                              style: _kTeamNameStyle,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }

  /// Builds the compact horizontal carousel card (280px width)
  Widget _buildCompactCard(BuildContext context, WidgetRef ref) {
    final isLive = event.isLive;
    final timeLabel = _formatTime(event.startTime);

    return RepaintBoundary(
      child: TvFocusable(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: isLive ? _kLiveCardDecoration : _kUpcomingCardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // League + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.league,
                      style: const TextStyle(
                        color: GoPlayTheme.onSurface,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isLive)
                    const LiveBadge()
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: _kCompactUpcomingBadgeDecoration,
                      child: const Text(
                        'UPCOMING',
                        style: TextStyle(
                          color: GoPlayTheme.onSurfaceVariant,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Teams & VS Info Row
              Expanded(
                child: Row(
                  children: [
                    // Teams Names & Flags
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Home Team
                          Row(
                            children: [
                              TeamFlagWidget(flag: event.homeTeam.flag, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  event.homeTeam.name,
                                  style: const TextStyle(
                                    color: GoPlayTheme.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Away Team
                          Row(
                            children: [
                              TeamFlagWidget(flag: event.awayTeam.flag, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  event.awayTeam.name,
                                  style: const TextStyle(
                                    color: GoPlayTheme.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Time / VS Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: _kCompactTimeBadgeDecoration,
                      child: Text(
                        isLive ? 'VS' : timeLabel,
                        style: TextStyle(
                          color: isLive
                              ? GoPlayTheme.primary
                              : GoPlayTheme.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
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
  }

  static bool _checkIsToday(DateTime startTime) {
    final now = DateTime.now();
    final localStart = startTime.toLocal();
    return localStart.year == now.year &&
        localStart.month == now.month &&
        localStart.day == now.day;
  }

  static String _formatTime(DateTime time) {
    final t = time.toLocal();
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final display = h % 12 == 0 ? 12 : h % 12;
    return '$display:$m $period';
  }

  static String _formatTimeInfo(SportEvent event) {
    if (event.isLive) return "${event.elapsedTime.inMinutes} MIN";

    final t = event.startTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDay = DateTime(t.year, t.month, t.day);

    if (eventDay == today) return 'TODAY';
    if (eventDay == tomorrow) return 'TOMORROW';
    return '${_kMonths[t.month - 1]} ${t.day.toString().padLeft(2, '0')}';
  }
}
