import 'package:flutter/material.dart';
import '../../core/theme.dart';
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

  static const _titleStyle = TextStyle(
    color: GoPlayTheme.onSurface,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
  );

  static const _actionStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Text(title.toUpperCase(), style: _titleStyle),
          const Spacer(),
          if (actionLabel != null)
            TvFocusable(
              borderRadius: BorderRadius.circular(6),
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(actionLabel!, style: _actionStyle),
              ),
            ),
        ],
      ),
    );
  }
}
