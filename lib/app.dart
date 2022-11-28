import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/navigation.dart';
import 'package:fwp/old_navigation.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/styles/styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class App extends ConsumerStatefulWidget {
  const App({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  List<SidebarItem> sidebarItems = [];
  ThemeData lightThemeData = ThemeData();
  ThemeData darkThemeData = ThemeData();

  final app = dotenv.env['APP'];

  @override
  void initState() {
    super.initState();

    setState(() {
      if (app == APP.thinkerview.name) {
        lightThemeData = ligthThemeDataThinkerview;
        darkThemeData = darkThemeDataThinkerview;
      } else if (app == APP.causecommune.name) {
        lightThemeData = ligthThemeDataCauseCommune;
        darkThemeData = darkThemeDataCauseCommune;
      }
    });

    initPlayback();
  }

  Future<void> initPlayback() async {
    await getIt<PlayerManager>().init();
    // await getIt<DatabaseHandler>().init();

    // final playerManager = getIt<PlayerManager>();
    // final episode =
    //     await getIt<DatabaseHandler>().getFirstEpisodePlayable();

    // if (episode.audioFileUrl.isNotEmpty) {
    //   playerManager.loadEpisode(episode);
    // }
  }

  final routerDelegate = BeamerDelegate(
    initialPath: '/a',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => const ScaffoldWithBottomNavBar(),
      },
    ),
  );

  @override
  Future<void> dispose() async {
    await getIt<PlayerManager>().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIt<PlayerManager>().ref = ref;

    if (Platform.isMacOS) {
      return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        home: const MainNavigation(),
      );
    }

    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
    );
  }
}
