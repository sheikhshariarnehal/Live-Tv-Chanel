import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../main.dart' show appInitFuture;
import '../../providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _bounceController;
  late final AnimationController _fadeController;

  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _bounceScale;
  late final Animation<double> _textFade;

  // Cached static decorations — not recreated per-frame
  static final _pulseRingDecoration = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: GoPlayTheme.primary, width: 3),
    boxShadow: [
      BoxShadow(
        color: GoPlayTheme.primary.withAlpha(76),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ],
  );

  static final _innerCircleDecoration = BoxDecoration(
    shape: BoxShape.circle,
    gradient: const LinearGradient(
      colors: [GoPlayTheme.primary, GoPlayTheme.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: GoPlayTheme.primary.withAlpha(128),
        blurRadius: 30,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    // ── Pulse Ring: scale 0.6→1.4, opacity 1→0, 1.8s loop ──
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    final pulseCurve = CurvedAnimation(
      parent: _pulseController,
      curve: const Cubic(0.24, 0, 0.38, 1),
    );
    _pulseScale = Tween<double>(begin: 0.6, end: 1.4).animate(pulseCurve);
    _pulseOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(pulseCurve);

    // ── Inner Circle Bounce: scale 1.0→0.92→1.0, 1.8s loop ──
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    // ── Text fade-in: 600ms ──
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    // ── Navigate when BOTH conditions are met:
    //    (a) appInitFuture completes (Hive+Supabase+Proxy ready)
    //    (b) minimum 900ms has elapsed (≥1 full animation cycle)
    //    Whichever is LAST wins — no artificial blocking if init is fast.
    Future.wait([
      appInitFuture,
      Future.delayed(const Duration(milliseconds: 900)),
    ]).then((_) {
      if (!mounted) return;
      
      // Initialize analytics service
      ref.read(analyticsServiceProvider).initialize();
      
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181C), // Carbon Black
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xFF222326), Color(0xFF17181C)],
              center: Alignment.center,
              radius: 1.0,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animated Logo ──────────────────────────────
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing outer ring
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (_, child) => Transform.scale(
                          scale: _pulseScale.value,
                          child: Opacity(
                            opacity: _pulseOpacity.value,
                            child: child,
                          ),
                        ),
                        child: DecoratedBox(
                          decoration: _pulseRingDecoration,
                          child: const SizedBox(width: 90, height: 90),
                        ),
                      ),
                      // Bouncing inner circle
                      AnimatedBuilder(
                        animation: _bounceController,
                        builder: (_, child) => Transform.scale(
                          scale: _bounceScale.value,
                          child: child,
                        ),
                        child: DecoratedBox(
                          decoration: _innerCircleDecoration,
                          child: const SizedBox(
                            width: 54,
                            height: 54,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 32,
                              color: Color(0xFF17181C), // Carbon Black
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Fading Text ────────────────────────────────
                FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFFFFF), GoPlayTheme.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'GoPlay',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 5.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'LIVE SPORTS STREAMING',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF71768E), // Alabaster Grey
                          letterSpacing: 6.0,
                        ),
                      ),
                    ],
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
