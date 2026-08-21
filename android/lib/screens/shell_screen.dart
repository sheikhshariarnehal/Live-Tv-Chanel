import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/typography.dart';
import '../widgets/tv_focus_wrapper.dart';

/// Main shell screen with bottom navigation bar.
///
/// Performance notes:
/// - MediaQuery accessed once, results passed down (avoids multiple rebuild subscriptions).
/// - Bottom nav wrapped in RepaintBoundary (isolated from page scroll repaints).
/// - Mobile nav items use lightweight InkWell with splash + haptic (no TvFocusable overhead).
/// - TV rail items keep TvFocusable for D-Pad focus visuals.
class ShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const ShellScreen({super.key, required this.navigationShell});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  late final List<FocusNode> _navFocusNodes;

  @override
  void initState() {
    super.initState();
    _navFocusNodes = List.generate(
      3,
      (i) => FocusNode(debugLabel: 'NavMenu_$i'),
    );
  }

  @override
  void dispose() {
    for (final node in _navFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = widget.navigationShell.currentIndex;

    // Scoped MediaQuery reads. `MediaQuery.of(context)` subscribes to every
    // field — including `viewInsets` — so it rebuilt the whole shell (and every
    // nav item) each time the keyboard opened.
    final size = MediaQuery.sizeOf(context);
    // TV & Landscape detection: TV devices, TV boxes, tablets, or any landscape screen (width > height)
    // use the Left Side Navigation Rail.
    // Mobile phones in portrait mode (width <= height) use the Bottom Navigation Bar.
    final isLandscape = size.width > size.height;
    final isTv = MediaQuery.navigationModeOf(context) == NavigationMode.directional ||
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    final isDesktop = isLandscape || isTv;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    Widget content;

    if (isDesktop) {
      content = Scaffold(
        body: Row(
          children: [
            // Side Navigation Rail — D-Pad friendly
            RepaintBoundary(
              child: Container(
                width: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F0F0F),
                  border: Border(
                    right: BorderSide(
                      color: Color(0x14FFFFFF),
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RailNavItem(
                        focusNode: _navFocusNodes[0],
                        icon: Icons.grid_view_outlined,
                        selectedIcon: Icons.grid_view_rounded,
                        label: 'Home',
                        isSelected: index == 0,
                        onTap: () => _goBranch(0),
                      ),
                      const SizedBox(height: 8),
                      _RailNavItem(
                        focusNode: _navFocusNodes[1],
                        icon: Icons.smart_display_outlined,
                        selectedIcon: Icons.smart_display_rounded,
                        label: 'Channels',
                        isSelected: index == 1,
                        onTap: () => _goBranch(1),
                      ),
                      const SizedBox(height: 8),
                      _RailNavItem(
                        focusNode: _navFocusNodes[2],
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
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    } else {
      content = Scaffold(
        extendBody: false,
        body: widget.navigationShell,
        bottomNavigationBar: RepaintBoundary(
          child: Container(
            height: 64 + bottomPadding,
            decoration: const BoxDecoration(
              color: Color(0xFF0F0F0F),
              border: Border(
                top: BorderSide(
                  color: Color(0x14FFFFFF),
                  width: 0.5,
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              children: [
                _NavItem(
                  focusNode: _navFocusNodes[0],
                  icon: Icons.grid_view_outlined,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Home',
                  isSelected: index == 0,
                  onTap: () => _goBranch(0),
                ),
                _NavItem(
                  focusNode: _navFocusNodes[1],
                  icon: Icons.smart_display_outlined,
                  selectedIcon: Icons.smart_display_rounded,
                  label: 'Channels',
                  isSelected: index == 1,
                  onTap: () => _goBranch(1),
                ),
                _NavItem(
                  focusNode: _navFocusNodes[2],
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
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
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

          // TV Remote D-Pad LEFT: Move left on page first.
          // ONLY jump to Navigation Menu when at the left-most edge of the page!
          if (key == LogicalKeyboardKey.arrowLeft) {
            final primary = FocusManager.instance.primaryFocus;
            if (primary != null && !_navFocusNodes.contains(primary)) {
              if (primary.context != null) {
                final moved = FocusTraversalGroup.of(primary.context!).inDirection(
                  primary,
                  TraversalDirection.left,
                );
                if (moved) {
                  return KeyEventResult.handled;
                }
              }
              _navFocusNodes[widget.navigationShell.currentIndex].requestFocus();
              return KeyEventResult.handled;
            }
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
  final FocusNode? focusNode;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.focusNode,
  });

  static final _borderRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: TvFocusable(
          focusNode: focusNode,
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: _borderRadius,
          child: Container(
            // 8dp of vertical air instead of 6, with a 22dp glyph instead of
            // 24: the bar keeps its 64dp height but the icon/label pair stops
            // filling it edge to edge.
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: GoPlayType.inter(
                        color: isSelected ? activeColor : inactiveColor,
                        fontSize: GoPlayType.xs,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        height: GoPlayType.leadingFlat,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
  final FocusNode? focusNode;

  const _RailNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.focusNode,
  });

  static final _borderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return TvFocusable(
      focusNode: focusNode,
      onTap: onTap,
      borderRadius: _borderRadius,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
              size: 24,
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: GoPlayType.inter(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: GoPlayType.xs,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  height: GoPlayType.leadingFlat,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
