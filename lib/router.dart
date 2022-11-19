import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/a',
  // navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/a',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const RootScreen(label: 'A', detailsPath: '/a/details'),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) => const DetailsScreen(label: 'A'),
            ),
          ],
        ),
        GoRoute(
          path: '/b',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const RootScreen(label: 'B', detailsPath: '/b/details'),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (context, state) => const DetailsScreen(label: 'B'),
            ),
          ],
        ),
      ],
    ),
  ],
);
