import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

/// Wraps any widget to make it fully navigable via Android TV / D-Pad remote control,
/// featuring visual focus indicators (glow, border highlight, scale up) and key handlers.
class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final double focusedScale;
  final Color? focusColor;

  const TvFocusable({
    super.key,
    required this.child,
    this.onTap,
    this.focusNode,
    this.autoFocus = false,
    this.borderRadius,
    this.isCircle = false,
    this.focusedScale = 1.0,
    this.focusColor,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
  }

  @override
  void dispose() {
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final lKey = event.logicalKey;
      final pKey = event.physicalKey;

      bool isSelect = lKey == LogicalKeyboardKey.select ||
          lKey == LogicalKeyboardKey.enter ||
          lKey == LogicalKeyboardKey.space ||
          lKey == LogicalKeyboardKey.gameButtonA ||
          lKey == LogicalKeyboardKey.accept ||
          lKey == LogicalKeyboardKey.numpadEnter ||
          pKey == PhysicalKeyboardKey.select ||
          pKey == PhysicalKeyboardKey.enter ||
          pKey == PhysicalKeyboardKey.space ||
          pKey == PhysicalKeyboardKey.numpadEnter ||
          lKey.keyId == 0x00000017 || // Android KEYCODE_DPAD_CENTER
          lKey.keyId == 0x00000042 || // Android KEYCODE_ENTER
          lKey.keyId == 0x00000060;   // Android KEYCODE_BUTTON_A

      if (!isSelect) {
        final name = lKey.debugName?.toLowerCase() ?? '';
        if (name.contains('dpad') ||
            name.contains('select') ||
            name.contains('enter') ||
            name.contains('center')) {
          isSelect = true;
        }
      }

      if (isSelect) {
        if (widget.onTap != null) {
          widget.onTap!();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = widget.focusColor ?? GoPlayTheme.primary;
    final isDpadOrKey = FocusManager.instance.highlightMode == FocusHighlightMode.traditional ||
        MediaQuery.of(context).navigationMode == NavigationMode.directional;
    final showVisuals = _isFocused && isDpadOrKey && FocusManager.instance.highlightMode != FocusHighlightMode.touch;

    final shape = widget.isCircle ? BoxShape.circle : BoxShape.rectangle;
    final borderRadius = widget.isCircle ? null : (widget.borderRadius ?? BorderRadius.circular(12));

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      onFocusChange: (focused) {
        if (mounted) {
          setState(() {
            _isFocused = focused;
          });
        }
      },
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: showVisuals ? widget.focusedScale : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              widget.child,
              if (showVisuals)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: shape,
                        borderRadius: borderRadius,
                        color: focusColor.withValues(alpha: 0.12),
                        border: Border.all(
                          color: focusColor,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
