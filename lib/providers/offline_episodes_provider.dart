import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

class OfflineEpisodesNotifier extends StateNotifier<List<Episode>> {
  OfflineEpisodesNotifier() : super([]);

  void addEpisode(Episode episode) {
    print("OfflineEpisodesNotifier addEpisode $episode");
    state = [...state, episode];
  }

  void removeEpisode(Episode episodeToBeRemoved) {
    state = [
      for (final episode in state)
        if (episode.id != episodeToBeRemoved.id) episode,
    ];
  }

  void updateEpisode(Episode episodeToBeUpdated) {
    final List<Episode> newState = [];
    for (final episode in state) {
      if (episode.id == episodeToBeUpdated.id) {
        return newState.add(episodeToBeUpdated);
      } else {
        return newState.add(episode);
      }
    }

    state = newState;
  }

  bool isOfflineEpisode(Episode episode) {
    for (final item in state) {
      if (episode.id == item.id) return true;
    }
    return false;
  }
}

final offlineEpisodesStateProvider =
    StateNotifierProvider<OfflineEpisodesNotifier, List<Episode>>((ref) {
  return OfflineEpisodesNotifier();
});
