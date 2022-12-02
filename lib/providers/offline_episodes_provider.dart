import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

final episodes = [
  Episode(
    id: 0,
    audioFileUrl: "toto",
    audioFilePath: "toto",
    articleUrl: "toto",
    date: "toto",
    title: "Episode 1",
    imageUrl: "https://loremflickr.com/320/240",
    description: "toto",
  ),
  Episode(
    id: 1,
    audioFileUrl: "toto",
    articleUrl: "toto",
    date: "toto",
    title: "Episode 2",
    imageUrl: "https://loremflickr.com/320/240",
    description: "toto",
  ),
];

class OfflineEpisodesNotifier extends StateNotifier<List<Episode>> {
  OfflineEpisodesNotifier() : super(episodes);

  void addOfflineEpisode(Episode episode) {
    state = [...state, episode];
  }

  void removeOfflineEpisode(Episode episodeToBeRemoved) {
    state = [
      for (final episode in state)
        if (episode.id != episodeToBeRemoved.id) episode,
    ];
  }
}

final offlineEpisodesStateProvider =
    StateNotifierProvider<OfflineEpisodesNotifier, List<Episode>>((ref) {
  return OfflineEpisodesNotifier();
});
