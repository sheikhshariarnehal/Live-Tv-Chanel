import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/shell_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/channels/channels_screen.dart';
import '../screens/upcoming/upcoming_screen.dart';
import '../screens/player/player_screen.dart';
import '../screens/search/search_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
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
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final channelId = state.pathParameters['channelId']!;
        return PlayerScreen(channelId: channelId);
      },
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
