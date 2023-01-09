import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/app.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/offline_download_wrapper.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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

  await FlutterDownloader.initialize(
    debug: kDebugMode,
    ignoreSsl: true,
  );

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en'), Locale('fr')],
      fallbackLocale: const Locale('fr'),
      child: const ProviderScope(
        child: OfflineDownloadWrapper(
          child: App(),
        ),
      ),
    ),
  );
}
