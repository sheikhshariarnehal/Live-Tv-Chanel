import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tv_focus_wrapper.dart';

/// Main shell screen with bottom navigation bar
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
    final isTv = MediaQuery.of(context).navigationMode == NavigationMode.directional;
    final isDesktop = isTv || MediaQuery.of(context).size.width >= 800;

    Widget content;

    if (isDesktop) {
      content = Scaffold(
        body: Row(
          children: [
            // Side Navigation Rail — custom D-Pad friendly
            Container(
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
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: index == 0,
                      onTap: () => _goBranch(0),
                    ),
                    const SizedBox(height: 8),
                    _RailNavItem(
                      icon: Icons.live_tv_outlined,
                      selectedIcon: Icons.live_tv_rounded,
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

            // Main Content Area
            Expanded(child: navigationShell),
          ],
        ),
      );
    } else {
      content = Scaffold(
        extendBody: false, // Solid bottom nav doesn't require transparent overlay
        body: navigationShell,
        bottomNavigationBar: Container(
          height: 64 + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
                width: 0.8,
              ),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
                isSelected: index == 0,
                onTap: () => _goBranch(0),
              ),
              _NavItem(
                icon: Icons.live_tv_outlined,
                selectedIcon: Icons.live_tv_rounded,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: TvFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : inactiveColor,
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return TvFocusable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
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
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : inactiveColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
