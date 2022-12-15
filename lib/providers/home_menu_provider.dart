import 'package:fwp/i18n.dart';
import 'package:riverpod/riverpod.dart';

enum HomeScreens { latestEpisodes, categories, offline }

const List<HomeScreens> homeScreens = <HomeScreens>[
  HomeScreens.latestEpisodes,
  HomeScreens.categories,
  HomeScreens.offline
];

extension HomeScreensExtension on HomeScreens {
  String translate() {
    switch (this) {
      case HomeScreens.latestEpisodes:
        return LocaleKeys.home_menu_latest_episodes.tr();
      case HomeScreens.categories:
        return LocaleKeys.home_menu_categories.tr();
      case HomeScreens.offline:
        return LocaleKeys.home_menu_offline.tr();
    }
  }
}

final homeMenuProvider =
    StateProvider<HomeScreens>((ref) => HomeScreens.latestEpisodes);
