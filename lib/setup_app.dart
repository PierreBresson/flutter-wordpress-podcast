import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/app.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<SentryEvent?> beforeSend(SentryEvent event, {dynamic hint}) async {
  final exceptions = event.exceptions;
  bool isHandled = false;

  if (exceptions!.isNotEmpty) {
    for (final exception in exceptions) {
      isHandled = exception.mechanism?.handled ?? isHandled;
    }
  }

  return isHandled ? null : event;
}

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load();
  await setupServiceLocator();

  final dsn = dotenv.env['DSN'];

  HttpOverrides.global = MyHttpOverrides();

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.sampleRate = kDebugMode ? 0 : 1.0;
      options.tracesSampleRate = 0.2;
      options.beforeSend = beforeSend;
    },
    appRunner: () => runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [Locale('en'), Locale('fr')],
        fallbackLocale: const Locale('fr'),
        child: const ProviderScope(
          child: App(),
        ),
      ),
    ),
  );
}
