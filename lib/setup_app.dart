import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/firebase_options_cause_commune.dart' as cause_commune;
import 'package:fwp/firebase_options_thinkerview.dart' as thinkerview;
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';

import 'app.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await setupServiceLocator();

  final app = dotenv.env['APP'];

  if (app == APP.thinkerview.name) {
    await Firebase.initializeApp(
      options: thinkerview.DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } else if (app == APP.causeCommune.name) {
    await Firebase.initializeApp(
      options: cause_commune.DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BottomBarNavigationCubit(),
        ),
        BlocProvider(
          create: (_) => PlayerCubit(),
        )
      ],
      child: const FwpApp(),
    ),
  );
}
