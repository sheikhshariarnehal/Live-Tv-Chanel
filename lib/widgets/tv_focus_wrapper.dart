import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

/// Platform-aware interaction wrapper.
///
/// On Android TV / D-Pad devices, lazily provisions FocusNodes and Focus widgets
/// with visual focus indicators (glow, border highlight, scale up) and key handlers.
///
/// On Mobile touch devices (phones/tablets), completely BYPASSES FocusNode allocation
/// and focus tree registration, providing instant Facebook/Telegram-style touch responsiveness
/// (haptics + 0ms pointer-down press scale down).
class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final double focusedScale;
  final Color? focusColor;
  final ValueChanged<bool>? onFocusChange;
  final FocusOnKeyEventCallback? onKeyEvent;

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
    this.onFocusChange,
    this.onKeyEvent,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  FocusNode? _focusNode;
  bool _isFocused = false;
  bool _isPressed = false;
  bool _ownsFocusNode = false;

  void _ensureFocusNode() {
    if (_focusNode == null) {
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
    }
  }

  @override
  void dispose() {
    if (_ownsFocusNode && _focusNode != null) {
      _focusNode!.dispose();
    }
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (widget.onKeyEvent != null) {
      final res = widget.onKeyEvent!(node, event);
      if (res != KeyEventResult.ignored) {
        return res;
      }
    }
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
          HapticFeedback.selectionClick();
          widget.onTap!();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    if (mounted) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_isPressed && mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (_isPressed && mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shape = widget.isCircle ? BoxShape.circle : BoxShape.rectangle;
    final borderRadius = widget.isCircle ? null : (widget.borderRadius ?? BorderRadius.circular(12));
    final focusColor = widget.focusColor ?? GoPlayTheme.primary;

    final double scale = _isPressed
        ? 0.97
        : (_isFocused ? widget.focusedScale : 1.0);

    final Widget content = Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: scale,
          duration: Duration(milliseconds: _isPressed ? 60 : 180),
          curve: _isPressed ? Curves.decelerate : Curves.easeOutCubic,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              widget.child,

              // Instant touch-down press overlay (Facebook/Telegram style)
              if (_isPressed)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: shape,
                        borderRadius: borderRadius,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                ),

              // TV D-Pad Focus Visuals — clean simple border highlight
              if (_isFocused)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: shape,
                        borderRadius: borderRadius,
                        color: focusColor.withValues(alpha: 0.15),
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

    _ensureFocusNode();

    return Focus(
      focusNode: _focusNode!,
      autofocus: widget.autoFocus,
      onFocusChange: (focused) {
        if (mounted) {
          setState(() {
            _isFocused = focused;
          });
          widget.onFocusChange?.call(focused);
        }
      },
      onKeyEvent: _handleKeyEvent,
      child: content,
    );
  }
}
