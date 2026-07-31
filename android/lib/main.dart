import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'core/router.dart';




import 'package:flutter/foundation.dart' show kIsWeb;
import 'utils/web_helper.dart';
import 'widgets/update_handler.dart';

// Global future that SplashScreen waits on before navigating.
// Completes when all heavy init is done.
late final Future<void> appInitFuture;

void main() {
  // Ensure binding is ready synchronously — very fast, no I/O.
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent uncaught Dart runtime exceptions from terminating the app process
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global FlutterError caught: ${details.exceptionAsString()}');
  };

  // Cap the image cache to avoid unbounded decoded-image GC pressure.
  // 200 images max; 80 MB total — covers a full search result page with headroom.
  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 * 1024 * 1024;

  // System UI — synchronous, no cost.
  try {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: GoPlayTheme.surfaceContainer,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  } catch (e) {
    debugPrint('Failed to set SystemUIOverlayStyle: $e');
  }

  // Kick off all heavy async init WITHOUT awaiting it here.
  // runApp() fires immediately so the first Flutter frame draws in < 50ms.
  appInitFuture = _initializeApp();

  runApp(const ProviderScope(child: GoPlayApp()));
}

/// Performs all heavy initialization in the background.
/// SplashScreen races this future against a minimum display timer.
Future<void> _initializeApp() async {
  try {
    // Hive + Supabase can run concurrently.
    await Future.wait([
      _initHive(),
      _initSupabase(),
    ]);
  } catch (e, stack) {
    debugPrint('Background init error (non-fatal): $e\n$stack');
  }
}

Future<void> _initHive() async {
  try {
    await Hive.initFlutter();
  } catch (e) {
    debugPrint('Hive.initFlutter error: $e');
  }

  final boxesToOpen = [
    AppConstants.settingsBox,
    AppConstants.channelsBox,
    AppConstants.eventsBox,
    AppConstants.categoriesBox,
    AppConstants.watchHistoryBox,
    AppConstants.favoritesBox,
    AppConstants.announcementsBox,
  ];

  for (final boxName in boxesToOpen) {
    await _openSafeBox(boxName);
  }
}

Future<void> _openSafeBox(String boxName) async {
  try {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  } catch (e) {
    debugPrint('Failed to open Hive box "$boxName": $e. Attempting clean recreate.');
    try {
      await Hive.deleteBoxFromDisk(boxName);
      await Hive.openBox(boxName);
    } catch (e2) {
      debugPrint('Critical: Could not recreate box "$boxName": $e2');
    }
  }
}

Future<void> _initSupabase() async {
  try {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      publishableKey: AppConstants.supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Supabase.initialize non-fatal error: $e');
  }
}

class GoPlayApp extends ConsumerWidget {
  const GoPlayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        removeLoadingSplash();
      });
    }
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: GoPlayTheme.darkTheme,
      routerConfig: appRouter,
      builder: (context, child) {
        return UpdateHandler(child: child!);
      },
    );
  }
}
