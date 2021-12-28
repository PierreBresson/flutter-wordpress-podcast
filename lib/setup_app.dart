import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/repositories/repositories.dart';
import 'app.dart';

Future<void> setupApp() async {
  runApp(
    RepositoryProvider(
      create: (_) => AudioPlayer(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BottomBarNavigationCubit(),
          )
        ],
        child: const FwpApp(),
      ),
    ),
  );
}
