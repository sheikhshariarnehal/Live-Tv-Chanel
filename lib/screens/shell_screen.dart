import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tv_focus_wrapper.dart';

/// Main shell screen with bottom navigation bar.
///
/// Performance notes:
/// - MediaQuery accessed once, results passed down (avoids multiple rebuild subscriptions).
/// - Bottom nav wrapped in RepaintBoundary (isolated from page scroll repaints).
/// - Mobile nav items use lightweight InkWell with splash + haptic (no TvFocusable overhead).
/// - TV rail items keep TvFocusable for D-Pad focus visuals.
class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ShellScreen({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = navigationShell.currentIndex;

    // Single MediaQuery read — avoids multiple rebuild subscriptions.
    final mq = MediaQuery.of(context);
    // TV detection: check directional nav mode, OR traditional focus highlight
    // mode (catches AOSP TV boxes that don't report directional), OR wide
    // screens >= 960px (typical TV resolution).
    final isTv = mq.navigationMode == NavigationMode.directional ||
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional ||
        mq.size.shortestSide >= 960;
    final isDesktop = isTv || mq.size.width >= 800;
    final bottomPadding = mq.padding.bottom;

    Widget content;

    if (isDesktop) {
      content = Scaffold(
        body: Row(
          children: [
            // Side Navigation Rail — D-Pad friendly
            RepaintBoundary(
              child: Container(
                width: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RailNavItem(
                        icon: Icons.grid_view_outlined,
                        selectedIcon: Icons.grid_view_rounded,
                        label: 'Home',
                        isSelected: index == 0,
                        onTap: () => _goBranch(0),
                      ),
                      const SizedBox(height: 8),
                      _RailNavItem(
                        icon: Icons.smart_display_outlined,
                        selectedIcon: Icons.smart_display_rounded,
                        label: 'Channels',
                        isSelected: index == 1,
                        onTap: () => _goBranch(1),
                      ),
                      const SizedBox(height: 8),
                      _RailNavItem(
                        icon: Icons.schedule_outlined,
                        selectedIcon: Icons.schedule_rounded,
                        label: 'Upcoming',
                        isSelected: index == 2,
                        onTap: () => _goBranch(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content Area
            Expanded(child: navigationShell),
          ],
        ),
      );
    } else {
      content = Scaffold(
        extendBody: false,
        body: navigationShell,
        bottomNavigationBar: RepaintBoundary(
          child: Container(
            height: 64 + bottomPadding,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.12),
                  width: 0.8,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.grid_view_outlined,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Home',
                  isSelected: index == 0,
                  onTap: () => _goBranch(0),
                ),
                _NavItem(
                  icon: Icons.smart_display_outlined,
                  selectedIcon: Icons.smart_display_rounded,
                  label: 'Channels',
                  isSelected: index == 1,
                  onTap: () => _goBranch(1),
                ),
                _NavItem(
                  icon: Icons.schedule_outlined,
                  selectedIcon: Icons.schedule_rounded,
                  label: 'Upcoming',
                  isSelected: index == 2,
                  onTap: () => _goBranch(2),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.digit1 ||
              key == LogicalKeyboardKey.numpad1) {
            _goBranch(0);
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit2 ||
                     key == LogicalKeyboardKey.numpad2) {
            _goBranch(1);
            return KeyEventResult.handled;
          } else if (key == LogicalKeyboardKey.digit3 ||
                     key == LogicalKeyboardKey.numpad3) {
            _goBranch(2);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: content,
    );
  }
}

// ─── Mobile Bottom Nav Item ──────────────────────────────────────
// Lightweight: InkWell with splash + haptic feedback.
// No TvFocusable overhead (Focus/Stack/AnimatedScale) on mobile.

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  // Cached border radius — avoids per-build allocation.
  static final _borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: _borderRadius,
        splashColor: activeColor.withValues(alpha: 0.12),
        highlightColor: activeColor.withValues(alpha: 0.06),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── TV Side Rail Nav Item ────────────────────────────────────────
// Keeps TvFocusable for D-Pad focus ring on TV/desktop.

class _RailNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static final _borderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return TvFocusable(
      onTap: onTap,
      borderRadius: _borderRadius,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: _borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
