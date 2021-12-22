import 'package:flutter/material.dart';
import 'package:fwp/style/style.dart';
import 'package:go_router/go_router.dart';

class FwpApp extends StatelessWidget {
  final GoRouter _router;

  const FwpApp({Key? key, required GoRouter router})
      : _router = router,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      theme: themeData,
    );
  }
}
