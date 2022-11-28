import 'package:fwp/i18n.dart';
import 'package:riverpod/riverpod.dart';

enum Screens { latestEpisodes, categories, offline }

const List<Screens> homeScreens = <Screens>[
  Screens.latestEpisodes,
  Screens.categories,
  Screens.offline
];

extension ScreensExtension on Screens {
  String translate() {
    switch (this) {
      case Screens.latestEpisodes:
        return LocaleKeys.home_menu_latest_episodes.tr();
      case Screens.categories:
        return LocaleKeys.home_menu_categories.tr();
      case Screens.offline:
        return LocaleKeys.home_menu_offline.tr();
    }
  }
}

final homeMenuProvider = StateProvider<Screens>((ref) => Screens.categories);
