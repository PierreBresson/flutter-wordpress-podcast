import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin PageMixin {
  Widget get child;
  String get path;
  String get subPath;

  GoRoute route({List<GoRoute> routes = const []}) => GoRoute(
        path: subPath,
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: child,
        ),
        routes: routes,
      );

  void push(BuildContext context) {
    context.push(path);
  }

  Future<void> go(
    BuildContext context, {
    Future? executeBeforeNavigation,
  }) async {
    if (executeBeforeNavigation != null) {
      final router = GoRouter.of(context);
      try {
        await executeBeforeNavigation;
      } catch (e) {
        //TODO: log error
      } finally {
        router.go(path);
      }
    } else {
      context.go(path);
    }
  }
}
