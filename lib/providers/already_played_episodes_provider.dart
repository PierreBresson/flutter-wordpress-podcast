import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

class AlreadyPlayedEpisodesNotifier extends StateNotifier<List<Episode>> {
  AlreadyPlayedEpisodesNotifier() : super([]);

  void updatePlayedEpisode(Episode episode) {
    if (state.map((item) => item.id).contains(episode.id)) {
      final List<Episode> newState = [];
      for (final item in state) {
        if (item.id == episode.id) {
          final Episode updatedEpisode = item;
          updatedEpisode.positionInSeconds = episode.positionInSeconds;
          newState.add(updatedEpisode);
        } else {
          newState.add(item);
        }
      }
      state = newState;
    } else {
      state = [...state, episode];
    }
  }

  void removePlayedEpisode(Episode episodeToBeRemoved) {
    state = [
      for (final episode in state)
        if (episode != episodeToBeRemoved) episode,
    ];
  }

  int getPlaybackPositionInSeconds(Episode episode) {
    int positionInSeconds = 0;
    for (final item in state) {
      if (item.id == episode.id) {
        positionInSeconds = item.positionInSeconds;
      }
    }
    return positionInSeconds;
  }
}

final alreadyPlayedEpisodesStateProvider =
    StateNotifierProvider<AlreadyPlayedEpisodesNotifier, List<Episode>>((ref) {
  return AlreadyPlayedEpisodesNotifier();
});
