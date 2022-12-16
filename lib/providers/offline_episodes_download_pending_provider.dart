import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwp/models/models.dart';

class OfflineEpisodesDownloadPendingNotifier
    extends StateNotifier<List<Episode>> {
  OfflineEpisodesDownloadPendingNotifier() : super([]);

  void addEpisode(Episode episode) {
    state = [...state, episode];
  }

  Episode? getEpisode(int id) {
    for (final episode in state) {
      if (episode.id == id) {
        return episode;
      }
    }
    return null;
  }

  bool hasEpisode(Episode episodeToBeFound) {
    final episode = state.firstWhereOrNull(
      (item) => item.id == episodeToBeFound.id,
    );
    if (episode != null) {
      return true;
    }
    return false;
  }

  void removeEpisodeById(Episode episodeToBeRemoved) {
    state = [
      for (final episode in state)
        if (episode.id != episodeToBeRemoved.id) episode,
    ];
  }

  Episode? getEpisodeFromTaskId(String audioFileDownloadTaskId) {
    Episode? episode;
    for (final item in state) {
      if (item.audioFileDownloadTaskId == audioFileDownloadTaskId) {
        episode = item;
      }
    }
    return episode;
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
}

final offlineEpisodesDownloadPendingStateProvider = StateNotifierProvider<
    OfflineEpisodesDownloadPendingNotifier, List<Episode>>((ref) {
  return OfflineEpisodesDownloadPendingNotifier();
});
