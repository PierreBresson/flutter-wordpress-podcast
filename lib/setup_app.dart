import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/blocs/blocs.dart';
import 'app.dart';

Future<void> setupApp() async {
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
