import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/app.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      options.tracesSampleRate = 0.2;
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
