import 'package:flutter/material.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/pages.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter({required TrackingRepository trackingRepository}) =>
    GoRouter(
      observers: [trackingRepository.routeObserver],
      routes: [
        HomePage().route(routes: [AboutPage().route()])
      ],
      errorPageBuilder: (context, state) => MaterialPage<void>(
        key: state.pageKey,
        child: Scaffold(
          body: Center(child: Text(state.error.toString())),
        ),
      ),
    );
