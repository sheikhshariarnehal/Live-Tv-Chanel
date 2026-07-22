import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../live_badge.dart';
import '../team_flag.dart';
import '../tv_focus_wrapper.dart';

const _kLiveCardDecoration = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8), // Alabaster Grey border
  ),
);

const _kUpcomingCardDecoration = BoxDecoration(
  gradient: GoPlayTheme.cardGradient,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.8), // Alabaster Grey border
  ),
);

const _kUpcomingBadgeDecoration = BoxDecoration(
  color: Color(0x0AFFFFFF), // white @ 4%
  borderRadius: BorderRadius.all(Radius.circular(4)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
  ),
);

const _kLiveTimeBadgeDecoration = BoxDecoration(
  color: Color(0x0DFFFFFF), // white @ 6%
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
  ),
);

const _kUpcomingTimeBadgeDecoration = BoxDecoration(
  color: Color(0x0DFFFFFF), // white @ 6%
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(
    BorderSide(color: GoPlayTheme.cardBorder, width: 0.5),
  ),
);

/// Compact match card for horizontal scrolling lists
class MatchCard extends StatelessWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.event, this.onTap});

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final hour = localTime.hour;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isLive = event.isLive;

    return RepaintBoundary(
      child: TvFocusable(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 12),
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
                      decoration: _kUpcomingBadgeDecoration,
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
                      decoration: isLive
                          ? _kLiveTimeBadgeDecoration
                          : _kUpcomingTimeBadgeDecoration,
                      child: Text(
                        isLive ? 'VS' : _formatTime(event.startTime),
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
}
