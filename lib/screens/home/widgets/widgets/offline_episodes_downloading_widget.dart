import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

class TaskEpisode {
  final int episodeId;
  final String name;
  final int progress;
  TaskEpisode({
    required this.episodeId,
    required this.name,
    required this.progress,
  });
}

List<TaskEpisode> getTaskEpisode({
  required List<Episode> episodesPendingDownload,
  required List<Task> tasks,
}) {
  final List<TaskEpisode> tasksEpisode = [];
  for (final episodePendingDownload in episodesPendingDownload) {
    final taskAudioFile = tasks.firstWhereOrNull(
      (task) => task.id == episodePendingDownload.audioFileDownloadTaskId,
    );
    final taskImage = tasks.firstWhereOrNull(
      (task) => task.id == episodePendingDownload.imageUrl,
    );
    if (taskAudioFile != null && taskImage != null) {
      final taskEpisode = TaskEpisode(
        episodeId: episodePendingDownload.id,
        name: episodePendingDownload.title,
        progress: ((taskAudioFile.progress + taskImage.progress) / 2).floor(),
      );
      tasksEpisode.add(taskEpisode);
    } else {
      if (kDebugMode) {
        print("TODO can't find corresponding task/episode");
      }
    }
  }
  return tasksEpisode;
}

class OfflineEpisodesDownloading extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO if both tasks are completed then remove episode from offlineEpisodesStateProvider
    // TODO : do it with a listener outside, maybe inside the offlinedownload wrapper
    //     final episode = ref
    //     .read(offlineEpisodesDownloadPendingStateProvider.notifier)
    //     .getEpisodeFromTaskId(taskId);
    // if (episode != null) {
    //   ref.read(offlineEpisodesStateProvider.notifier).addEpisode(episode);
    // } else {
    //   if (kDebugMode) {
    //     print(
    //       "TODO error offline download wrapper episode with task id $taskId could not be found",
    //     );
    //   }
    // }
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
          name: tasksEpisode[index].name,
          progress: tasksEpisode[index].progress,
          onTap: () {},
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
