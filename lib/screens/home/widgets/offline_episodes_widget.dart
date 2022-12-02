import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineEpisodes extends HookConsumerWidget {
  const OfflineEpisodes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = ref.watch(offlineEpisodesStateProvider);

    if (episodes.isEmpty) {
      return Center(
        child: Text(LocaleKeys.offline_episodes_widget_no_offline_episode.tr()),
      );
    }

    return ListView.separated(
      separatorBuilder: (context, _) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        return EpisodeCard(episode: episodes[index]);
      },
    );
  }
}
