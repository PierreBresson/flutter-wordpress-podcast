import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/screens.dart';
import 'package:fwp/styles/styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class FwpApp extends ConsumerStatefulWidget {
  const FwpApp({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FwpAppState();
}

class _FwpAppState extends ConsumerState<FwpApp> {
  List<String> screensTitle = ["Accueil", "Lecteur", "Livres", "A propos"];
  List<Widget> screens = [];
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];
  List<SidebarItem> sidebarItems = [];
  ThemeData lightThemeData = ThemeData();
  ThemeData darkThemeData = ThemeData();
  MacosThemeData darkThemeDataMacOS = MacosThemeData();
  MacosThemeData lightThemeDataMacOS = MacosThemeData();
  final ScrollController _homeController = ScrollController();

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

      screens = [
        HomeScreen(
          scrollController: _homeController,
        ),
        const PlayerScreen(),
        const SearchScreen(),
        const BooksScreen(),
        const AboutScreen()
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

      screens = [
        HomeScreen(
          scrollController: _homeController,
        ),
        const PlayerScreen(),
        const SearchScreen(),
        const AboutScreen(),
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
    await getIt<PlayerManager>().init();
    // await getIt<DatabaseHandler>().init();

    // final playerManager = getIt<PlayerManager>();
    // final episodePlayable =
    //     await getIt<DatabaseHandler>().getFirstEpisodePlayable();

    // if (episodePlayable.audioFileUrl.isNotEmpty) {
    //   playerManager.loadEpisodePlayable(episodePlayable);
    // }
  }

  @override
  Future<void> dispose() async {
    await getIt<PlayerManager>().dispose();

    super.dispose();
  }

  void updateTabIndexProvider(int tabIndex) {
    ref.read(tabIndexProvider.notifier).update((state) => tabIndex);
    if (tabIndex == 0) {
      if (_homeController.hasClients) {
        _homeController.jumpTo(_homeController.position.minScrollExtent);
      }
    }
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
    final brightness = SchedulerBinding.instance.window.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    getIt<PlayerManager>().ref = ref;

    if (Platform.isMacOS) {
      return MacosApp(
        title: getTitle(),
        theme: lightThemeDataMacOS,
        darkTheme: darkThemeDataMacOS,
        themeMode: ref.watch(themeModeProvider),
        debugShowCheckedModeBanner: false,
        home: MacosWindow(
          sidebar: Sidebar(
            minWidth: 200,
            builder: (context, controller) {
              return SidebarItems(
                currentIndex: ref.watch(tabIndexProvider),
                onChanged: (index) => updateTabIndexProvider(index),
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
              index: ref.watch(tabIndexProvider),
              children: screens,
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: Scaffold(
        body: IndexedStack(
          index: ref.watch(tabIndexProvider),
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: bottomNavigationBarItems,
          currentIndex: ref.watch(tabIndexProvider),
          onTap: (index) => updateTabIndexProvider(index),
        ),
      ),
    );
  }
}
