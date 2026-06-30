import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../live_badge.dart';

/// Compact match card for horizontal scrolling lists
class MatchCard extends StatelessWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: GoPlayTheme.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: event.isLive
                ? GoPlayTheme.liveBadge.withAlpha(60)
                : GoPlayTheme.cardBorder,
            width: event.isLive ? 1 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // League + Status
            Row(
              children: [
                if (event.isLive) ...[
                  const LiveBadge(),
                  const SizedBox(width: 8),
                ] else ...[
                  Icon(Icons.schedule, size: 12, color: GoPlayTheme.primary),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    event.league,
                    style: TextStyle(
                      color: event.isLive
                          ? GoPlayTheme.liveBadge
                          : GoPlayTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Teams
            Row(
              children: [
                // Home team
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        event.homeTeam.flag ?? '🏳️',
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.homeTeam.name,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // VS / Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: GoPlayTheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.isLive ? 'VS' : _formatTime(event.startTime),
                    style: TextStyle(
                      color: event.isLive ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                // Away team
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        event.awayTeam.flag ?? '🏳️',
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.awayTeam.name,
                        style: const TextStyle(
                          color: GoPlayTheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Sport tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: GoPlayTheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                event.sport,
                style: TextStyle(
                  color: GoPlayTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
