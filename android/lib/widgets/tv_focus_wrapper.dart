import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

/// Platform-aware interaction wrapper.
///
/// On Android TV / D-Pad devices this provisions a [FocusNode] and a [Focus]
/// widget with visual focus indicators (border highlight, scale up) and key
/// handlers.
///
/// On mobile touch devices it genuinely skips FocusNode allocation, focus-tree
/// registration and the implicit-animation controller, leaving only a
/// [Listener] + [GestureDetector] and an instant press transform. The previous
/// implementation documented this fast path but never took it: it called
/// `_ensureFocusNode()` and wrapped in `Focus` + `AnimatedScale`
/// unconditionally, so every grid card allocated a FocusNode *and* an
/// AnimationController and churned both on every fling.
class TvFocusable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final double focusedScale;
  final Color? focusColor;
  final ValueChanged<bool>? onFocusChange;
  final FocusOnKeyEventCallback? onKeyEvent;

  /// Optional accessibility label. When provided the wrapper exposes itself as
  /// a single semantic button instead of leaking its children's nodes.
  final String? semanticLabel;

  const TvFocusable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.focusNode,
    this.autoFocus = false,
    this.borderRadius,
    this.isCircle = false,
    this.focusedScale = 1.0,
    this.focusColor,
    this.onFocusChange,
    this.onKeyEvent,
    this.semanticLabel,
  });

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  FocusNode? _focusNode;
  bool _isFocused = false;
  bool _isPressed = false;
  bool _ownsFocusNode = false;
  bool _highlightIsTraditional = false;

  @override
  void initState() {
    super.initState();
    _highlightIsTraditional =
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    // The old code read `highlightMode` during build without subscribing, so
    // plugging in a remote mid-session never enabled focus visuals.
    FocusManager.instance.addHighlightModeListener(_onHighlightModeChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onHighlightModeChanged);
    if (_ownsFocusNode) _focusNode?.dispose();
    super.dispose();
  }

  void _onHighlightModeChanged(FocusHighlightMode mode) {
    final isTraditional = mode == FocusHighlightMode.traditional;
    if (isTraditional == _highlightIsTraditional) return;
    if (!mounted) return;
    setState(() => _highlightIsTraditional = isTraditional);
  }

  FocusNode _ensureFocusNode() {
    final existing = _focusNode;
    if (existing != null) return existing;
    if (widget.focusNode != null) {
      _ownsFocusNode = false;
      return _focusNode = widget.focusNode!;
    }
    _ownsFocusNode = true;
    return _focusNode = FocusNode(debugLabel: 'TvFocusable');
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (widget.onKeyEvent != null) {
      final res = widget.onKeyEvent!(node, event);
      if (res != KeyEventResult.ignored) return res;
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

      if (isSelect && widget.onTap != null) {
        HapticFeedback.selectionClick();
        widget.onTap!();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _setPressed(bool value) {
    if (_isPressed == value || !mounted) return;
    setState(() => _isPressed = value);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    HapticFeedback.selectionClick();
    _setPressed(true);
  }

  @override
  Widget build(BuildContext context) {
    // Scoped read: the old `MediaQuery.of(context)` subscribed to *every*
    // MediaQuery field, so opening the search keyboard (viewInsets change)
    // rebuilt every card in the grid.
    final isDpadMode = _highlightIsTraditional ||
        MediaQuery.navigationModeOf(context) == NavigationMode.directional;

    // Focus is also required when a caller drives focus explicitly (nav rail
    // items pass a node and/or autofocus), regardless of input mode.
    final needsFocus = isDpadMode || widget.focusNode != null || widget.autoFocus;

    final shape = widget.isCircle ? BoxShape.circle : BoxShape.rectangle;
    final borderRadius =
        widget.isCircle ? null : (widget.borderRadius ?? BorderRadius.circular(12));
    final focusColor = widget.focusColor ?? GoPlayTheme.primary;
    final showFocusRing = _isFocused && isDpadMode;

    Widget visual = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        widget.child,

        // Instant touch-down press overlay.
        if (_isPressed)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: shape,
                  borderRadius: borderRadius,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),

        // D-Pad focus ring.
        if (showFocusRing)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: shape,
                  borderRadius: borderRadius,
                  color: focusColor.withValues(alpha: 0.15),
                  border: Border.all(color: focusColor, width: 2.0),
                ),
              ),
            ),
          ),
      ],
    );

    if (isDpadMode) {
      // TV: focus transitions are few and deliberate, so an implicit animation
      // is worth its AnimationController here.
      final double scale =
          _isPressed ? 0.97 : (_isFocused ? widget.focusedScale : 1.0);
      visual = AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: _isPressed ? 60 : 180),
        curve: _isPressed ? Curves.decelerate : Curves.easeOutCubic,
        child: visual,
      );
    } else if (_isPressed) {
      // Touch: instant transform, no controller allocated per card.
      visual = Transform.scale(scale: 0.97, child: visual);
    }

    Widget content = Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        behavior: HitTestBehavior.opaque,
        child: visual,
      ),
    );

    if (widget.semanticLabel != null) {
      content = Semantics(
        container: true,
        button: widget.onTap != null,
        label: widget.semanticLabel,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        excludeSemantics: true,
        child: content,
      );
    }

    if (!needsFocus) return content;

    return Focus(
      focusNode: _ensureFocusNode(),
      autofocus: widget.autoFocus,
      onFocusChange: (focused) {
        if (!mounted) return;
        setState(() => _isFocused = focused);
        widget.onFocusChange?.call(focused);
      },
      onKeyEvent: _handleKeyEvent,
      child: content,
    );
  }
}
