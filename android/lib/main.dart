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
import 'services/local_proxy.dart';
import 'widgets/update_handler.dart';

// Global future that SplashScreen waits on before navigating.
// Completes when all heavy init is done.
late final Future<void> appInitFuture;

void main() {
  // Ensure binding is ready synchronously — very fast, no I/O.
  WidgetsFlutterBinding.ensureInitialized();

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
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(AppConstants.settingsBox),
    Hive.openBox(AppConstants.channelsBox),
    Hive.openBox(AppConstants.eventsBox),
    Hive.openBox(AppConstants.categoriesBox),
  ]);
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
