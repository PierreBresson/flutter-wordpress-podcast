import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PodcastProgressDownloadIndicator extends HookConsumerWidget {
  final TaskEpisode taskEpisode;

  const PodcastProgressDownloadIndicator({
    super.key,
    required this.taskEpisode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        "${taskEpisode.progress} % - ${taskEpisode.name}",
        maxLines: 1,
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: const Icon(
        Icons.cancel,
        size: 24,
      ),
      onTap: () async {
        final Episode? episode = ref
            .read(offlineEpisodesDownloadPendingStateProvider.notifier)
            .getEpisode(taskEpisode.episodeId);

        if (episode != null) {
          ref
              .read(offlineEpisodesDownloadPendingStateProvider.notifier)
              .removeEpisodeById(episode);

          print("TODO : fix FlutterDownloader.remove crash");
          print(episode.audioFileDownloadTaskId);
          print(episode.imageDownloadTaskId);

          if (episode.audioFileDownloadTaskId != null) {
            ref
                .read(tasksStateProvider.notifier)
                .removeTaskById(episode.audioFileDownloadTaskId!);

            final audioTask = ref
                .read(tasksStateProvider.notifier)
                .getTask(episode.audioFileDownloadTaskId!);

            if (audioTask != null) {
              try {
                await FlutterDownloader.remove(
                  taskId: episode.audioFileDownloadTaskId!,
                  shouldDeleteContent: true,
                );
              } catch (error) {
                if (kDebugMode) {
                  print(
                    "TODO PodcastProgressDownloadIndicator remove audioFileDownloadTaskId failed with episode ${episode.toString()}",
                  );
                }
              }
            }
          } else {
            if (kDebugMode) {
              print(
                "TODO PodcastProgressDownloadIndicator delete failed because episode with id ${episode.id} has audioFileDownloadTaskId property null",
              );
            }
          }

          if (episode.imageDownloadTaskId != null) {
            ref
                .read(tasksStateProvider.notifier)
                .removeTaskById(episode.imageDownloadTaskId!);

            final imageTask = ref
                .read(tasksStateProvider.notifier)
                .getTask(episode.imageDownloadTaskId!);

            if (imageTask != null) {
              try {
                await FlutterDownloader.remove(
                  taskId: episode.imageDownloadTaskId!,
                  shouldDeleteContent: true,
                );
              } catch (error) {
                if (kDebugMode) {
                  print(
                    "TODO PodcastProgressDownloadIndicator remove imageDownloadTaskId failed with episode ${episode.toString()}",
                  );
                }
              }
            }
          } else {
            if (kDebugMode) {
              print(
                "TODO PodcastProgressDownloadIndicator delete failed because episode with id ${episode.id} has imageDownloadTaskId property null",
              );
            }
          }
        } else {
          if (kDebugMode) {
            print(
              "TODO PodcastProgressDownloadIndicator delete failed because episode with id ${taskEpisode.episodeId} can't be found",
            );
          }
        }
      },
    );
  }
}
