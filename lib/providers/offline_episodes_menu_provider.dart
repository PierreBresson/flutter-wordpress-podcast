import 'package:fwp/i18n.dart';
import 'package:riverpod/riverpod.dart';

enum OfflineEpisodesScreens { downloaded, inDownload }

const List<OfflineEpisodesScreens> episodesScreens = <OfflineEpisodesScreens>[
  OfflineEpisodesScreens.downloaded,
  OfflineEpisodesScreens.inDownload,
];

extension OfflineEpisodesScreensExtension on OfflineEpisodesScreens {
  String translate() {
    switch (this) {
      case OfflineEpisodesScreens.downloaded:
        return LocaleKeys.offline_episodes_widget_downloaded.tr();
      case OfflineEpisodesScreens.inDownload:
        return LocaleKeys.offline_episodes_widget_in_download.tr();
    }
  }
}

final offlineDownloadsMenuProvider = StateProvider<OfflineEpisodesScreens>(
  (ref) => OfflineEpisodesScreens.downloaded,
);
