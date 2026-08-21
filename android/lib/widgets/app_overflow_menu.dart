import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/typography.dart';
import '../providers/app_providers.dart';

/// Lightweight, compact, and responsive 3-dot overflow menu.
class AppOverflowMenu extends ConsumerWidget {
  final Color? iconColor;

  const AppOverflowMenu({super.key, this.iconColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final color = iconColor ?? cs.onSurface.withValues(alpha: 0.85);

    return Focus(
      canRequestFocus: false,
      child: Theme(
        // Override popup menu theme locally for instant, lightweight rendering
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF16171A),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: GoPlayTheme.cardBorder,
                width: 0.6,
              ),
            ),
          ),
        ),
        child: PopupMenuButton<String>(
          tooltip: 'Options',
          position: PopupMenuPosition.under,
          offset: const Offset(0, 4),
          elevation: 2,
          color: const Color(0xFF16171A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: GoPlayTheme.cardBorder,
              width: 0.6,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 148, maxWidth: 170),
          icon: Icon(
            Icons.more_vert_rounded,
            color: color,
            size: 20,
          ),
          onSelected: (value) {
            if (value == 'favorites') {
              ref.read(selectedCategoryProvider.notifier).select('favorite');
              context.go('/channels');
            } else if (value == 'settings') {
              context.push('/settings');
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'favorites',
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_outline_rounded,
                    color: cs.onSurface.withValues(alpha: 0.85),
                    size: 17,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: GoPlayType.sm,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<String>(
              value: 'settings',
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    color: cs.onSurface.withValues(alpha: 0.85),
                    size: 17,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: GoPlayType.family,
                      fontSize: GoPlayType.sm,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                      letterSpacing: -0.1,
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
