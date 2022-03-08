import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/screens.dart';
import 'package:fwp/styles/styles.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

class FwpApp extends StatefulWidget {
  const FwpApp({
    Key? key,
  }) : super(key: key);

  @override
  State<FwpApp> createState() => _FwpAppState();
}

class _FwpAppState extends State<FwpApp> {
  List<String> screensTitle = ["Accueil", "Lecteur", "Livres", "A propos"];
  List<Widget> screens = [];
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];
  List<SidebarItem> sidebarItems = [];
  ThemeData lightThemeData = ThemeData();
  ThemeData darkThemeData = ThemeData();
  MacosThemeData darkThemeDataMacOS = MacosThemeData();
  MacosThemeData lightThemeDataMacOS = MacosThemeData();

  final app = dotenv.env['APP'];

  @override
  void initState() {
    super.initState();

    if (app == APP.thinkerview.name) {
      lightThemeData = ligthThemeDataThinkerview;
      darkThemeData = darkThemeDataThinkerview;
      lightThemeDataMacOS = lightThemeDataMacOSThinkerview;
      darkThemeDataMacOS = darkThemeDataMacOSThinkerview;
      screensTitle = ["Accueil", "Lecteur", "Recherche", "Livres", "A propos"];

      screens = const [
        HomeScreen(),
        PlayerScreen(),
        SearchScreen(),
        BooksScreen(),
        AboutScreen()
      ];

      bottomNavigationBarItems = [
        BottomNavigationBarItem(
          icon: const Icon(Icons.house),
          label: screensTitle[0],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.music_note),
          label: screensTitle[1],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: screensTitle[2],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: screensTitle[3],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.info),
          label: screensTitle[4],
        )
      ];
    } else if (app == APP.causecommune.name) {
      lightThemeData = ligthThemeDataCauseCommune;
      darkThemeData = darkThemeDataCauseCommune;
      lightThemeDataMacOS = lightThemeDataMacOSCauseCommune;
      darkThemeDataMacOS = darkThemeDataMacOSCauseCommune;
      screensTitle = ["Accueil", "Lecteur", "Recherche", "A propos"];

      screens = const [
        HomeScreen(),
        PlayerScreen(),
        SearchScreen(),
        AboutScreen(),
      ];

      bottomNavigationBarItems = [
        BottomNavigationBarItem(
          icon: const Icon(Icons.house),
          label: screensTitle[0],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.music_note),
          label: screensTitle[1],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: screensTitle[2],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.info),
          label: screensTitle[3],
        )
      ];
    }

    initPlayback();
  }

  List<SidebarItem> getSidebar({required bool isDarkMode}) {
    if (app == APP.thinkerview.name) {
      return [
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.home,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          label: Text(
            screensTitle[0],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.music_note,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          label: Text(
            screensTitle[1],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.search,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          label: Text(
            screensTitle[2],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.book,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          label: Text(
            screensTitle[3],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.info,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          label: Text(
            screensTitle[4],
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ];
    }
    return [
      SidebarItem(
        leading: MacosIcon(
          CupertinoIcons.home,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        label: Text(
          screensTitle[0],
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      SidebarItem(
        leading: MacosIcon(
          CupertinoIcons.music_note,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        label: Text(
          screensTitle[1],
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      SidebarItem(
        leading: MacosIcon(
          CupertinoIcons.search,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        label: Text(
          screensTitle[2],
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      SidebarItem(
        leading: MacosIcon(
          CupertinoIcons.info,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        label: Text(
          screensTitle[3],
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    ];
  }

  Future<void> initPlayback() async {
    await getIt<DatabaseHandler>().init();
    await getIt<PlayerManager>().init();

    final playerManager = getIt<PlayerManager>();
    final episodePlayable =
        await getIt<DatabaseHandler>().getFirstEpisodePlayable();

    if (episodePlayable.audioFileUrl.isNotEmpty) {
      playerManager.loadEpisodePlayable(episodePlayable);
    }
  }

  @override
  Future<void> dispose() async {
    await getIt<PlayerManager>().dispose();
    await getIt<DatabaseHandler>().dispose();

    super.dispose();
  }

  String getTitle() {
    if (app == APP.thinkerview.name) {
      return "Thinkerview";
    } else if (app == APP.causecommune.name) {
      return "Cause Commune";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    if (Platform.isMacOS) {
      return ChangeNotifierProvider(
        create: (_) => AppTheme(),
        builder: (context, _) {
          final appTheme = context.watch<AppTheme>();
          return MacosApp(
            title: getTitle(),
            theme: lightThemeDataMacOS,
            darkTheme: darkThemeDataMacOS,
            themeMode: appTheme.mode,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<NavigationCubit, int>(
              builder: (_, index) => MacosWindow(
                sidebar: Sidebar(
                  minWidth: 200,
                  builder: (context, controller) {
                    return SidebarItems(
                      currentIndex: index,
                      onChanged: (index) =>
                          context.read<NavigationCubit>().update(index),
                      scrollController: controller,
                      items: getSidebar(isDarkMode: isDarkMode),
                    );
                  },
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: lightThemeData,
                  darkTheme: darkThemeData,
                  home: IndexedStack(
                    index: index,
                    children: screens,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: BlocBuilder<NavigationCubit, int>(
        builder: (_, index) => Scaffold(
          body: IndexedStack(
            index: index,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: bottomNavigationBarItems,
            currentIndex: index,
            onTap: (index) => context.read<NavigationCubit>().update(index),
          ),
        ),
      ),
    );
  }
}
