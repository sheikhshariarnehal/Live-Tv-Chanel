import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/shell_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/channels/channels_screen.dart';
import '../screens/upcoming/upcoming_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/settings/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
        GoRoute(
          path: '/channels',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ChannelsScreen(),
          ),
        ),
        GoRoute(
          path: '/upcoming',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: UpcomingScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/player/:channelId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final channelId = state.pathParameters['channelId']!;
        List<String>? eventChannels;
        bool forceFullscreen = false;

        if (state.extra is Map<String, dynamic>) {
          final extra = state.extra as Map<String, dynamic>;
          eventChannels = extra['eventChannels'] as List<String>?;
          forceFullscreen = extra['forceFullscreen'] as bool? ?? false;
        }

        return PlayerScreen(
          channelId: channelId,
          eventChannels: eventChannels,
          forceFullscreen: forceFullscreen,
        );
      },
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
