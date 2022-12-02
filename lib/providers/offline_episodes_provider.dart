import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

final fakeEpisodes = [
  Episode(
    id: 0,
    audioFileUrl:
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    articleUrl: "toto",
    date: "toto",
    title: "Episode 1",
    imageUrl: "https://loremflickr.com/320/240",
    description: "toto",
  ),
  Episode(
    id: 1,
    audioFileUrl:
        "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    audioFilePath: "some path",
    articleUrl: "toto",
    date: "toto",
    title: "Episode 2",
    imageUrl: "https://loremflickr.com/320/240",
    description: "toto",
  ),
];

class OfflineEpisodesNotifier extends StateNotifier<List<Episode>> {
  OfflineEpisodesNotifier() : super(fakeEpisodes);

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
