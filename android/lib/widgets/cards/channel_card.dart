import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme.dart';
import '../../core/typography.dart';
import '../../models/channel.dart';
import '../../providers/app_providers.dart';
import '../tv_focus_wrapper.dart';

/// Logical height of the card's fixed (non-text) content: vertical padding,
/// the logo avatar, and the gap beneath it.
///
/// [ChannelCard.measureHeight] uses this so the grid can pick a
/// `childAspectRatio` that always fits, at any text scale and tile width.
const double _kCardVerticalPadding = 8.0;
const double _kAvatarSize = 54.0;
const double _kAvatarGap = 8.0;
const double _kNameFontSize = GoPlayType.xs;
const double _kNameLineHeight = GoPlayType.leadingSnug;
const int _kNameMaxLines = 2;

/// Channel grid card.
///
/// A [ConsumerWidget] so it can watch *only its own* favorite flag. The parent
/// grid previously watched the whole `Set<String>` and passed `isFavorite` down,
/// which rebuilt every visible card on any toggle — and the card ignored the
/// value anyway, so no favorite affordance ever rendered.
class ChannelCard extends ConsumerWidget {
  final Channel channel;

  const ChannelCard({super.key, required this.channel});

  /// Minimum tile height needed to render this card without overflowing at the
  /// caller's current text scale.
  static double measureHeight(BuildContext context) {
    final scaled = MediaQuery.textScalerOf(context).scale(_kNameFontSize);
    final nameBlock = scaled * _kNameLineHeight * _kNameMaxLines;
    return (_kCardVerticalPadding * 2) +
        _kAvatarSize +
        _kAvatarGap +
        nameBlock;
  }

  void _toggleFavorite(WidgetRef ref) {
    HapticFeedback.mediumImpact();
    ref.read(favoriteChannelIdsProvider.notifier).toggle(channel.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    // Narrow selector: rebuilds this card only when *this* channel's favorite
    // state flips.
    final isFavorite = ref.watch(
      favoriteChannelIdsProvider.select((ids) => ids.contains(channel.id)),
    );

    final quality = channel.quality?.trim();
    final hasQuality = quality != null && quality.isNotEmpty;
    final is4K = quality == '4K';

    final badgeBase = is4K ? const Color(0xFF3B82F6) : GoPlayTheme.primary;
    final badgeText =
        isDark ? badgeBase : Color.lerp(badgeBase, Colors.black, 0.35)!;

    final initials = Center(
      child: Text(
        channel.initials,
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: GoPlayType.base,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );

    return TvFocusable(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.push('/player/${channel.id}'),
      onLongPress: () => _toggleFavorite(ref),
      // Restores accessibility: the grid used to be wrapped in
      // ExcludeSemantics, hiding every channel from screen readers. One
      // container node per card keeps the tree small without hiding content.
      semanticLabel: hasQuality
          ? '${channel.displayName}, $quality${isFavorite ? ', favorite' : ''}'
          : '${channel.displayName}${isFavorite ? ', favorite' : ''}',
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.fromBorderSide(
              BorderSide(color: cs.outline, width: 0.8),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Main content ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: _kCardVerticalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: SizedBox(
                        width: _kAvatarSize,
                        height: _kAvatarSize,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: cs.onSurface.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: cs.outline, width: 1.0),
                            ),
                          ),
                          child: channel.logo != null && channel.logo!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: channel.logo!,
                                  fit: BoxFit.cover,
                                  width: _kAvatarSize,
                                  height: _kAvatarSize,
                                  memCacheWidth: 108,
                                  memCacheHeight: 108,
                                  fadeInDuration:
                                      const Duration(milliseconds: 150),
                                  imageBuilder: (context, imageProvider) =>
                                      DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => initials,
                                  errorWidget: (context, url, err) => initials,
                                )
                              : initials,
                        ),
                      ),
                    ),
                    const SizedBox(height: _kAvatarGap),
                    // Flexible so the name can never push the column past the
                    // tile height — the old fixed layout overflowed on 320dp
                    // widths and at any text scale above ~1.15.
                    Flexible(
                      child: Text(
                        channel.displayName,
                        style: GoPlayType.inter(
                          color: cs.onSurface,
                          fontSize: _kNameFontSize,
                          fontWeight: FontWeight.w600,
                          height: _kNameLineHeight,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: _kNameMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Quality badge ─────────────────────────────────
              if (hasQuality)
                Positioned(
                  top: 6,
                  left: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: badgeBase.withValues(alpha: isDark ? 0.12 : 0.14),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: badgeBase.withValues(alpha: 0.22),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      child: Text(
                        quality,
                        style: GoPlayType.meta.copyWith(color: badgeText),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),

              // ── Favorite indicator ────────────────────────────
              // Long-press toggles. Deliberately not a button: a second tap
              // target on a ~100dp tile competes with "open channel" and would
              // be below the minimum touch-target size.
              if (isFavorite)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.bookmark_rounded,
                    size: 14,
                    color: GoPlayTheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
