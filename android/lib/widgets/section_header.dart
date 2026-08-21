import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import 'tv_focus_wrapper.dart';

/// Section header with title and optional action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  /// The top of the screen's type hierarchy.
  ///
  /// Previously this was tracked uppercase in the stepped-back secondary
  /// colour. Uppercasing the titles alongside the already-uppercase league and
  /// status badges left the screen with no quiet register — every line shouted
  /// — and the wide tracking pulled "TRENDING CHANNELS" apart until it stopped
  /// reading as one phrase. Normal case at [GoPlayType.sectionTitle] in the
  /// primary text colour makes the heading the anchor it should be, and hands
  /// the uppercase voice back to the short status tokens that earn it.
  static final _titleStyle = GoPlayType.sectionTitle.copyWith(
    color: GoPlayTheme.onSurface,
  );

  /// Medium weight, stepped back one tone: the way *out* of a section should
  /// never compete with the section itself.
  static final _actionStyle = GoPlayType.sectionAction.copyWith(
    color: GoPlayTheme.onSurfaceVariant,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 0, bottom: 6),
      child: Row(
        // Both sides are single-line, so centre alignment reads as balanced.
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: GoPlayTheme.onSurface, size: 20),
            const SizedBox(width: 8),
          ],
          // Expanded, not Spacer: the title can come from remote data, so it
          // has to be allowed to ellipsize rather than overflow the row at
          // 1.3x text scale.
          Expanded(
            child: Text(
              title,
              style: _titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionLabel != null)
            TvFocusable(
              borderRadius: BorderRadius.circular(8),
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  actionLabel!,
                  style: _actionStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
