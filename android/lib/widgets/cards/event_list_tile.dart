import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../live_badge.dart';
import '../team_flag.dart';
import '../countdown_timer.dart';

/// Full-width event list tile used in Upcoming and Today's Schedule
class EventListTile extends StatelessWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const EventListTile({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: GoPlayTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: event.isLive
                ? GoPlayTheme.liveBadge.withAlpha(40)
                : GoPlayTheme.cardBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Row: Match Title (League) + Status Badge
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
                if (event.isLive)
                  const LiveBadge(
                    fontSize: 8,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: GoPlayTheme.onSurfaceVariant.withAlpha(40),
                        width: 0.5,
                      ),
                    ),
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
            // Teams & Score/Time Row
            Row(
              children: [
                // Home team
                SizedBox(
                  width: 48,
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flag: event.homeTeam.flag,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _abbreviate(event.homeTeam.name),
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),

                // Score / Time
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.isLive ? 'VS' : _formatTime(event.startTime),
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      () {
                        final now = DateTime.now();
                        final localStart = event.startTime.toLocal();
                        final isToday = localStart.year == now.year &&
                            localStart.month == now.month &&
                            localStart.day == now.day;

                        if (event.isUpcoming && isToday) {
                          return CountdownTimerWidget(
                            startTime: event.startTime,
                            style: const TextStyle(
                              color: GoPlayTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Text(
                          _formatTimeInfo(event),
                          style: const TextStyle(
                            color: GoPlayTheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        );
                      }(),
                    ],
                  ),
                ),

                // Away team
                SizedBox(
                  width: 48,
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flag: event.awayTeam.flag,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _abbreviate(event.awayTeam.name),
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _abbreviate(String name) {
    if (name.length <= 3) return name.toUpperCase();
    return name.substring(0, 3).toUpperCase();
  }

  String _formatTime(DateTime time) {
    final localTime = time.toLocal();
    final hour = localTime.hour;
    final minute = localTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }

  String _formatTimeInfo(SportEvent event) {
    if (event.isLive) {
      final elapsed = event.elapsedTime;
      return '${elapsed.inMinutes}\'';
    }
    
    final localTime = event.startTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final eventDay = DateTime(localTime.year, localTime.month, localTime.day);
    
    if (eventDay == today) {
      return 'TODAY';
    } else if (eventDay == tomorrow) {
      return 'TOMORROW';
    } else {
      final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      return '${months[localTime.month - 1]} ${localTime.day.toString().padLeft(2, '0')}';
    }
  }
}
