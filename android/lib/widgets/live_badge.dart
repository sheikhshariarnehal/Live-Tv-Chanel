import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/typography.dart';

/// Pulsing LIVE badge — uses FadeTransition (single compositing layer)
/// instead of rebuilding the entire widget tree on every animation tick.
///
/// Deliberately small. On a live event card the badge is the *second* red mark
/// in the row — the card already carries the red accent bar on its left edge —
/// so a full-size pulsing pill next to it meant two things shouting the same
/// word. The pill is now tight enough to read as a stamp rather than a button.
/// [fontSize] stays at the [GoPlayType.xs] legibility floor; the size comes off
/// the padding and the dot instead.
class LiveBadge extends StatefulWidget {
  final double fontSize;
  final EdgeInsets padding;

  const LiveBadge({
    super.key,
    this.fontSize = GoPlayType.xs,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.6, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: GoPlayTheme.liveBadge,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: widget.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 5,
                  height: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  'LIVE',
                  style: GoPlayType.meta.copyWith(
                    color: Colors.white,
                    fontSize: widget.fontSize,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
