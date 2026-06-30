import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../live_badge.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            // Home team
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    event.homeTeam.flag ?? '🏳️',
                    style: const TextStyle(fontSize: 22),
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
                children: [
                  Text(
                    event.isLive ? 'VS' : _formatTime(event.startTime),
                    style: TextStyle(
                      color: GoPlayTheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTimeInfo(event),
                    style: TextStyle(
                      color: GoPlayTheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Away team
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    event.awayTeam.flag ?? '🏳️',
                    style: const TextStyle(fontSize: 22),
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

            const SizedBox(width: 12),

            // League + Status badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  event.league,
                  style: const TextStyle(
                    color: GoPlayTheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (event.isLive)
                  const LiveBadge(fontSize: 9)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: GoPlayTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'UPCOMING',
                      style: TextStyle(
                        color: GoPlayTheme.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
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
    final h = time.toLocal().hour.toString().padLeft(2, '0');
    final m = time.toLocal().minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatTimeInfo(SportEvent event) {
    if (event.isLive) {
      final elapsed = event.elapsedTime;
      return '${elapsed.inMinutes}\'';
    }
    return _formatTime(event.startTime);
  }
}
