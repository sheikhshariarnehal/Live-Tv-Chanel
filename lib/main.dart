import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants.dart';
import 'core/theme.dart';
import 'core/router.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js_interop' as js;

@js.JS('eval')
external void _jsEval(js.JSString script);

void removeLoadingSplash() {
  if (kIsWeb) {
    try {
      _jsEval('''
        var splash = document.getElementById("loading-splash");
        if (splash) {
          splash.classList.add("fade-out");
          setTimeout(function() {
            splash.remove();
          }, 400);
        }
      '''.toJS);
    } catch (e) {
      // Ignore errors
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: GoPlayTheme.surfaceContainer,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: GoPlayApp()));
}

class GoPlayApp extends StatelessWidget {
  const GoPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
