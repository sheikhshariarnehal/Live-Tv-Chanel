import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main shell screen with bottom navigation bar
class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/channels')) return 1;
    if (location.startsWith('/upcoming')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = _selectedIndex(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Side Navigation Rail
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    width: 0.5,
                  ),
                ),
              ),
              child: NavigationRail(
                selectedIndex: index,
                onDestinationSelected: (i) {
                  switch (i) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/channels');
                      break;
                    case 2:
                      context.go('/upcoming');
                      break;
                  }
                },
                backgroundColor: theme.colorScheme.surface,
                indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.home_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      'Home',
                      style: TextStyle(
                        color: index == 0
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.live_tv_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.live_tv_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      'Channels',
                      style: TextStyle(
                        color: index == 1
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.schedule_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    selectedIcon: Icon(
                      Icons.schedule_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      'Upcoming',
                      style: TextStyle(
                        color: index == 2
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: false, // Solid bottom nav doesn't require transparent overlay
      body: child,
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
              onTap: () => context.go('/home'),
            ),
            _NavItem(
              icon: Icons.live_tv_outlined,
              selectedIcon: Icons.live_tv_rounded,
              label: 'Channels',
              isSelected: index == 1,
              onTap: () => context.go('/channels'),
            ),
            _NavItem(
              icon: Icons.schedule_outlined,
              selectedIcon: Icons.schedule_rounded,
              label: 'Upcoming',
              isSelected: index == 2,
              onTap: () => context.go('/upcoming'),
            ),
          ],
        ),
      ),
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
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 23,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
