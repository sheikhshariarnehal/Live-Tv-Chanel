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

  /// Crisp section action link with accent color.
  static final _actionStyle = GoPlayType.sectionAction.copyWith(
    color: GoPlayTheme.primary,
  );

  @override
  Widget build(BuildContext context) {
    final hasAction = onAction != null;

    final headerContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: GoPlayTheme.onSurface, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title,
            style: _titleStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasAction) ...[
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            size: 24,
            color: GoPlayTheme.onSurface,
          ),
        ],
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: hasAction
          ? Align(
              alignment: Alignment.centerLeft,
              child: TvFocusable(
                borderRadius: BorderRadius.circular(8),
                onTap: onAction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: headerContent,
                ),
              ),
            )
          : headerContent,
    );
  }
}
