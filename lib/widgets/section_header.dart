import 'package:flutter/material.dart';
import '../../core/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: GoPlayTheme.primary, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: GoPlayTheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  color: GoPlayTheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
