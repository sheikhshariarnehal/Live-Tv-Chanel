import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../../providers/app_providers.dart';
import '../live_badge.dart';
import '../team_flag.dart';
import '../countdown_timer.dart';
import '../tv_focus_wrapper.dart';

// ─── Pre-computed static constants ───────────────────────────────────────────
// Allocated once at class-load time; never re-created during builds/scrolls.

const _kLiveCardDecoration = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 1.0), // Alabaster Grey border
  ),
  boxShadow: [
    BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0371768E), blurRadius: 24, spreadRadius: 1), // Alabaster Grey shadow @ 2%
  ],
);

const _kUpcomingCardDecoration = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 1.0), // Alabaster Grey border
  ),
  boxShadow: [
    BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0371768E), blurRadius: 24, spreadRadius: 1), // Alabaster Grey shadow @ 2%
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

const _kLeagueStyle = TextStyle(
  color: GoPlayTheme.onSurfaceVariant, // Alabaster Grey
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
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.2,
);

const _kCountdownStyle = TextStyle(
  color: GoPlayTheme.primary,
  fontSize: 10,
  fontWeight: FontWeight.w800,
);

const _kTimeInfoStyle = TextStyle(
  color: GoPlayTheme.onSurfaceVariant, // Alabaster Grey
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

// ─── Months lookup — allocated once ─────────────────────────────────────────
const _kMonths = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];

class EventListTile extends ConsumerStatefulWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const EventListTile({super.key, required this.event, this.onTap});

  @override
  ConsumerState<EventListTile> createState() => _EventListTileState();
}

class _EventListTileState extends ConsumerState<EventListTile> {
  // Cached values derived from event — recomputed only when event changes.
  late String _homeName;
  late String _awayName;
  late String _timeLabel;
  late bool _isToday;

  @override
  void initState() {
    super.initState();
    _updateCache();
  }

  @override
  void didUpdateWidget(EventListTile old) {
    super.didUpdateWidget(old);
    if (old.event != widget.event) _updateCache();
  }

  void _updateCache() {
    final event = widget.event;
    _homeName = event.homeTeam.name;
    _awayName = event.awayTeam.name;
    _timeLabel = _formatTime(event.startTime);

    final now = DateTime.now();
    final localStart = event.startTime.toLocal();
    _isToday =
        localStart.year == now.year &&
        localStart.month == now.month &&
        localStart.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isLive = event.isLive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RepaintBoundary(
        child: TvFocusable(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: GestureDetector(
            onTap: widget.onTap,
            child: DecoratedBox(
              decoration: isLive
                  ? _kLiveCardDecoration
                  : _kUpcomingCardDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    // Teams & time row
                    Row(
                      children: [
                        // Home team
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TeamFlagWidget(flag: event.homeTeam.flag, size: 24),
                              const SizedBox(height: 4),
                              Text(
                                _homeName,
                                style: _kTeamNameStyle,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Centre: score / time / countdown
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLive ? 'VS' : _timeLabel,
                                style: isLive
                                    ? _kLiveTimeStyle
                                    : _kUpcomingTimeStyle,
                              ),
                              const SizedBox(height: 4),
                              if (event.isUpcoming && _isToday)
                                CountdownTimerWidget(
                                  startTime: event.startTime,
                                  onTimerFinished: () {
                                    ref.read(syncServiceProvider).sync();
                                    ref.invalidate(eventsProvider);
                                  },
                                  style: _kCountdownStyle,
                                )
                              else
                                Text(
                                  _formatTimeInfo(event),
                                  style: _kTimeInfoStyle,
                                ),
                            ],
                          ),
                        ),

                        // Away team
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TeamFlagWidget(flag: event.awayTeam.flag, size: 24),
                              const SizedBox(height: 4),
                              Text(
                                _awayName,
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

  static String _formatTime(DateTime time) {
    final t = time.toLocal();
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final display = h % 12 == 0 ? 12 : h % 12;
    return '$display:$m $period';
  }

  static String _formatTimeInfo(SportEvent event) {
    if (event.isLive) return "${event.elapsedTime.inMinutes}'";

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
