import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/app.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
  initializeDateFormatting('fr_FR');
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load();
  await setupServiceLocator();

  final dsn = dotenv.env['DSN'];

  await SentryFlutter.init(
    (options) {
      options.dsn = dsn;
      options.sampleRate = kDebugMode ? 0 : 1.0;
      options.tracesSampleRate = 0.2;
      options.beforeSend = beforeSend;
    },
    appRunner: () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BottomBarNavigationCubit(),
          ),
        ],
        child: const FwpApp(),
      ),
    ),
  );
}
