import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayedEpisodesNotifier extends StateNotifier<List<int>> {
  PlayedEpisodesNotifier() : super([]);

  void addPlayedEpisode(int id) {
    state = [...state, id];
  }

  void removePlayedEpisode(int idToBeRemoved) {
    state = [
      for (final id in state)
        if (id != idToBeRemoved) id,
    ];
  }
}

final playedEpisodesStateProvider =
    StateNotifierProvider<PlayedEpisodesNotifier, List<int>>((ref) {
  return PlayedEpisodesNotifier();
});
