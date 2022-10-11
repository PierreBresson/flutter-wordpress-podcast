import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final episodesProvider = FutureProvider<List<EpisodePlayable>>((ref) async {
  final List<Episode> episodes = await ref.read(httpRepository).getEpisodes();
  final List<EpisodePlayable> episodePlayables = episodes
      .map(
        (episode) => EpisodePlayable(
          id: episode.id,
          date: episode.date,
          audioFileUrl: episode.audioFileUrl,
          articleUrl: episode.articleUrl,
          imageUrl: episode.imageUrl,
          title: episode.title,
          description: episode.description,
        ),
      )
      .toList();

  return episodePlayables;
});
