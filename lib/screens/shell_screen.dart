import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

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
    final index = _selectedIndex(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Side Navigation Rail
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: GoPlayTheme.cardBorder,
                    width: 0.5,
                  ),
                ),
              ),
              child: NavigationRail(
                selectedIndex: index,
                onDestinationSelected: (i) {
                  switch (i) {
                    case 0:
                      context.go('/');
                      break;
                    case 1:
                      context.go('/channels');
                      break;
                    case 2:
                      context.go('/upcoming');
                      break;
                  }
                },
                backgroundColor: GoPlayTheme.surfaceContainer,
                indicatorColor: GoPlayTheme.primary.withAlpha(25),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.home_outlined, color: GoPlayTheme.onSurfaceVariant),
                    selectedIcon: const Icon(Icons.home_rounded, color: GoPlayTheme.primary),
                    label: Text(
                      'Home',
                      style: TextStyle(
                        color: index == 0 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.live_tv_outlined, color: GoPlayTheme.onSurfaceVariant),
                    selectedIcon: const Icon(Icons.live_tv_rounded, color: GoPlayTheme.primary),
                    label: Text(
                      'Channels',
                      style: TextStyle(
                        color: index == 1 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.schedule_outlined, color: GoPlayTheme.onSurfaceVariant),
                    selectedIcon: const Icon(Icons.schedule_rounded, color: GoPlayTheme.primary),
                    label: Text(
                      'Upcoming',
                      style: TextStyle(
                        color: index == 2 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant,
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
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: GoPlayTheme.cardBorder,
              width: 0.5,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) {
            switch (i) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/channels');
                break;
              case 2:
                context.go('/upcoming');
                break;
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: index == 0 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant),
              selectedIcon: const Icon(Icons.home_rounded, color: GoPlayTheme.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.live_tv_outlined, color: index == 1 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant),
              selectedIcon: const Icon(Icons.live_tv_rounded, color: GoPlayTheme.primary),
              label: 'Channels',
            ),
            NavigationDestination(
              icon: Icon(Icons.schedule_outlined, color: index == 2 ? GoPlayTheme.primary : GoPlayTheme.onSurfaceVariant),
              selectedIcon: const Icon(Icons.schedule_rounded, color: GoPlayTheme.primary),
              label: 'Upcoming',
            ),
          ],
        ),
      ),
    );
  }
}
