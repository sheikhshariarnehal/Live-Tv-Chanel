import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:media_kit/media_kit.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'core/router.dart';



import 'package:flutter/foundation.dart' show kIsWeb;
import 'utils/web_helper.dart';
import 'services/local_proxy.dart';
import 'widgets/update_handler.dart';

// Global future that SplashScreen waits on before navigating.
// Completes when all heavy init is done.
late final Future<void> appInitFuture;

void main() {
  // Ensure binding is ready synchronously — very fast, no I/O.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit for cross-platform video playback (Windows/Linux/macOS).
  MediaKit.ensureInitialized();

  // Cap the image cache to avoid unbounded decoded-image GC pressure.
  // 150 images max; 50 MB total — covers a full search result page with headroom.
  PaintingBinding.instance.imageCache.maximumSize = 150;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  // System UI — synchronous, no cost.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: GoPlayTheme.surfaceContainer,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Kick off all heavy async init WITHOUT awaiting it here.
  // runApp() fires immediately so the first Flutter frame draws in < 50ms.
  appInitFuture = _initializeApp();

  runApp(const ProviderScope(child: GoPlayApp()));
}

/// Performs all heavy initialization in the background.
/// SplashScreen races this future against a minimum display timer.
Future<void> _initializeApp() async {
  // Start local proxy in parallel with Hive+Supabase init.
  final proxyFuture = kIsWeb ? Future.value() : LocalProxy.start();

  // Hive + Supabase can run concurrently.
  await Future.wait([
    proxyFuture,
    _initHive(),
    _initSupabase(),
  ]);
}

Future<void> _initHive() async {
  if (kIsWeb) {
    // On web, Hive uses IndexedDB — no path needed.
    await Hive.initFlutter();
  } else {
    // Use the app-private support directory instead of Documents.
    // Documents is shared and any other process can interfere with .lock files.
    // getApplicationSupportDirectory() → AppData\Roaming\<bundle-id>\ on Windows.
    final supportDir = await getApplicationSupportDirectory();
    final hiveDir = Directory('${supportDir.path}/hive');
    if (!hiveDir.existsSync()) hiveDir.createSync(recursive: true);

    // Clean up any stale .lock files from a previous crashed instance.
    try {
      final lockFiles = hiveDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.lock'));
      for (final f in lockFiles) {
        try { f.deleteSync(); } catch (_) {}
      }
    } catch (_) {}

    Hive.init(hiveDir.path);
  }

  // Open each box individually so a single failure doesn't block the others.
  final boxNames = [
    AppConstants.settingsBox,
    AppConstants.channelsBox,
    AppConstants.eventsBox,
    AppConstants.categoriesBox,
  ];
  await Future.wait(
    boxNames.map((name) async {
      try {
        if (!Hive.isBoxOpen(name)) {
          await Hive.openBox(name);
        }
      } catch (e) {
        debugPrint('Hive: failed to open box "$name": $e');
      }
    }),
  );
}

Future<void> _initSupabase() async {
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );
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
