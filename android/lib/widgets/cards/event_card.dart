import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
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
    BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
  ],
);

const _kUpcomingCardDecoration = BoxDecoration(
  color: GoPlayTheme.darkSurfaceContainer,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8),
  ),
  boxShadow: [
    BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 2)),
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
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurfaceVariant,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w700,
  height: GoPlayType.leadingFlat,
  letterSpacing: GoPlayType.trackingMeta,
);

const _kBadgeStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurfaceVariant,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w800,
  height: GoPlayType.leadingFlat,
  letterSpacing: GoPlayType.trackingMeta,
);

const _kTeamNameStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurface,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w600,
  height: GoPlayType.leadingFlat,
);

// The countdown is supporting information, not the headline. At w800 in full
// Signal Teal it read as loud as the kickoff time directly above it, so the
// pair had no hierarchy — two strong lines competing in a 3-line column. Medium
// weight in a dimmed teal keeps the "this is a clock, it is teal, it is
// counting" signal while stepping clearly behind the time.
const _kCountdownStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: Color(0xB300ADB5), // Signal Teal @ 70%
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w600,
  height: GoPlayType.leadingFlat,
);

const _kTimeInfoStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurfaceVariant,
  fontSize: GoPlayType.xs,
  fontWeight: FontWeight.w600,
  height: GoPlayType.leadingFlat,
);

// Kickoff numerals. Tracking stays at 0 — the old -0.5 closed the digit
// counters at this size and made times like "21:45" run together. Weight comes
// down from w900: the time is already the largest thing in its column, so it
// does not also need the heaviest stroke in the card.
const _kLiveTimeStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.primary,
  fontSize: GoPlayType.md,
  fontWeight: FontWeight.w800,
  height: GoPlayType.leadingFlat,
);

const _kUpcomingTimeStyle = TextStyle(
  fontFamily: GoPlayType.family,
  color: GoPlayTheme.onSurface,
  fontSize: GoPlayType.base,
  fontWeight: FontWeight.w800,
  height: GoPlayType.leadingFlat,
);

const _kMonths = [
  'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
  'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
];

// ─── Tile geometry ───────────────────────────────────────────────────────────
// The tile used to be a hard-coded 96dp box. That number only fit at a text
// scale of 1.0; at the 1.3 ceiling the app allows, the two-line team names
// pushed the column past the box. Measuring instead of guessing lets the card
// come down ~12% at the default scale — which is what buys the extra fixture on
// screen — while still growing when the user scales text up.
const double _kTilePadV = 7.0;
const double _kTileBadgePadV = 2.0;
const double _kTileHeaderGap = 5.0;
const double _kTileFlagSize = 22.0;
const double _kTileFlagGap = 2.0;
const int _kTileNameLines = 2;

/// Vertical gap beneath each tile. Callers driving a fixed-extent list need
/// [tileExtent], which folds this in.
const double _kTileGap = 4.0;

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

  /// Painted height of one [EventCardVariant.tile] at the caller's text scale.
  ///
  /// ~84dp at scale 1.0, down from the old fixed 96dp.
  static double tileHeight(BuildContext context) {
    final metaLine =
        MediaQuery.textScalerOf(context).scale(GoPlayType.xs) *
            GoPlayType.leadingFlat;

    // Header: the LIVE / UPCOMING pill is the tallest thing in the row.
    final header = metaLine + (_kTileBadgePadV * 2);

    // Teams: flag, gap, then the two-line name block. The centre column
    // (time + countdown) is always shorter than this, so it never sets the row.
    final teams =
        _kTileFlagSize + _kTileFlagGap + (metaLine * _kTileNameLines);

    // +1 absorbs sub-pixel rounding so the column can never overflow by a hair.
    return (_kTilePadV * 2) + header + _kTileHeaderGap + teams + 1;
  }

  /// [tileHeight] plus the gap beneath it — the value a `SliverFixedExtentList`
  /// or `mainAxisExtent` needs.
  static double tileExtent(BuildContext context) =>
      tileHeight(context) + _kTileGap;

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
      padding: const EdgeInsets.only(bottom: _kTileGap),
      child: RepaintBoundary(
        child: TvFocusable(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            height: tileHeight(context),
            child: DecoratedBox(
              decoration: isLive ? _kLiveCardDecoration : _kUpcomingCardDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: _kTilePadV,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(width: 8),
                       if (isLive)
                         const LiveBadge(
                           padding: EdgeInsets.symmetric(
                             horizontal: 6,
                             vertical: _kTileBadgePadV,
                           ),
                         )
                       else
                         const DecoratedBox(
                           decoration: _kUpcomingBadgeDecoration,
                           child: Padding(
                             padding: EdgeInsets.symmetric(
                               horizontal: 7,
                               vertical: _kTileBadgePadV,
                             ),
                             child: Text(
                               'UPCOMING',
                               style: _kBadgeStyle,
                               maxLines: 1,
                             ),
                           ),
                         ),
                    ],
                  ),
                  const SizedBox(height: _kTileHeaderGap),
                  // Teams & Time row. Expanded, not a fixed block: the height
                  // above is measured from this row's content, and letting it
                  // flex means any rounding slack lands here instead of
                  // overflowing the card.
                  Expanded(
                    child: Row(
                    children: [
                      // Home team
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TeamFlagWidget(
                              flag: event.homeTeam.flag,
                              size: _kTileFlagSize,
                            ),
                            const SizedBox(height: _kTileFlagGap),
                            Text(
                              event.homeTeam.name,
                              style: _kTeamNameStyle,
                              maxLines: _kTileNameLines,
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
                            const SizedBox(height: 2),
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
                            TeamFlagWidget(
                              flag: event.awayTeam.flag,
                              size: _kTileFlagSize,
                            ),
                            const SizedBox(height: _kTileFlagGap),
                            Text(
                              event.awayTeam.name,
                              style: _kTeamNameStyle,
                              maxLines: _kTileNameLines,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                      style: _kLeagueStyle.copyWith(
                        color: GoPlayTheme.onSurface,
                      ),
                      maxLines: 1,
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
                        style: _kBadgeStyle,
                        maxLines: 1,
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
                                  style: GoPlayType.labelSmall.copyWith(
                                    color: GoPlayTheme.onSurface,
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
                                  style: GoPlayType.labelSmall.copyWith(
                                    color: GoPlayTheme.onSurface,
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
                        style: GoPlayType.meta.copyWith(
                          color: isLive
                              ? GoPlayTheme.primary
                              : GoPlayTheme.onSurfaceVariant,
                          letterSpacing: 0,
                        ),
                        maxLines: 1,
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
