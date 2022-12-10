import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/selectors/selectors.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineEpisodesDownloading extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Task> tasks = ref.watch(tasksStateProvider);
    final List<Episode> episodesPendingDownload =
        ref.watch(offlineEpisodesDownloadPendingStateProvider);
    final List<TaskEpisode> tasksEpisode = getTaskEpisode(
      episodesPendingDownload: episodesPendingDownload,
      tasks: tasks,
    );

    if (tasksEpisode.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys
              .offline_episodes_downloading_widget_no_offline_episode_in_download
              .tr(),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        return PodcastProgressDownloadIndicator(
          taskEpisode: tasksEpisode[index],
        );
      },
      separatorBuilder: (context, _) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: tasksEpisode.length,
    );
  }
}
