import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/event.dart';
import '../live_badge.dart';
import '../team_flag.dart';

/// Compact match card for horizontal scrolling lists
class MatchCard extends StatelessWidget {
  final SportEvent event;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.event, this.onTap});

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                if (event.isLive)
                  const LiveBadge()
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
                            TeamFlagWidget(
                              flag: event.homeTeam.flag,
                              size: 20,
                            ),
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
                            TeamFlagWidget(
                              flag: event.awayTeam.flag,
                              size: 20,
                            ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: event.isLive
                          ? GoPlayTheme.liveBadge.withAlpha(20)
                          : GoPlayTheme.surfaceContainerHighest.withAlpha(120),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: event.isLive
                            ? GoPlayTheme.liveBadge.withAlpha(40)
                            : Colors.transparent,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      event.isLive ? 'VS' : _formatTime(event.startTime),
                      style: TextStyle(
                        color: event.isLive ? GoPlayTheme.liveBadge : GoPlayTheme.onSurfaceVariant,
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
    );
  }
}
