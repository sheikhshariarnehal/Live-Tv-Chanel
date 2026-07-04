import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme.dart';
import '../models/channel.dart';

/// Reusable lightweight channel avatar — extracted to avoid duplicating
/// the same logo/initials code in TrendingChannels and RecentlyWatched.
class ChannelAvatar extends StatelessWidget {
  final Channel channel;
  final double size;
  final bool showBorder;

  const ChannelAvatar({
    super.key,
    required this.channel,
    this.size = 52,
    this.showBorder = true,
  });

  static const _initialsStyle = TextStyle(
    color: GoPlayTheme.primary,
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) {
    final initials = channel.name
        .substring(0, channel.name.length >= 2 ? 2 : 1)
        .toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: GoPlayTheme.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: channel.isLive
                    ? const Color(0x5000E676) // GoPlayTheme.primary @ 31%
                    : GoPlayTheme.cardBorder,
                width: 2,
              )
            : null,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: channel.logo != null && channel.logo!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: channel.logo!,
                  fit: BoxFit.cover,
                  memCacheWidth: (size * 2).toInt(),
                  memCacheHeight: (size * 2).toInt(),
                  fadeInDuration: const Duration(milliseconds: 150),
                  placeholder: (context, url) =>
                      Center(child: Text(initials, style: _initialsStyle)),
                  errorWidget: (context, url, error) =>
                      Center(child: Text(initials, style: _initialsStyle)),
                )
              : Center(child: Text(initials, style: _initialsStyle)),
        ),
      ),
    );
  }
}
