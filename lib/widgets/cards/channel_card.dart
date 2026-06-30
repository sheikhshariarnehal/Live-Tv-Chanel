import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../models/channel.dart';

/// Channel card widget for the channel grid
class ChannelCard extends StatelessWidget {
  final Channel channel;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ChannelCard({
    super.key,
    required this.channel,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/player/${channel.id}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: GoPlayTheme.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GoPlayTheme.cardBorder, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: GoPlayTheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    channel.name.substring(0, channel.name.length >= 2 ? 2 : 1).toUpperCase(),
                    style: TextStyle(
                      color: GoPlayTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Name
              Text(
                channel.name,
                style: const TextStyle(
                  color: GoPlayTheme.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Category + Quality
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (channel.quality != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: GoPlayTheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        channel.quality!,
                        style: TextStyle(
                          color: GoPlayTheme.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  if (channel.isLive)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: GoPlayTheme.liveBadge,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: GoPlayTheme.liveBadge.withAlpha(80),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Favorite button
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  size: 18,
                  color: isFavorite ? GoPlayTheme.liveBadge : GoPlayTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
