import 'package:collection/collection.dart';
import 'package:fwp/models/models.dart';

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
      (task) => task.id == episodePendingDownload.imageDownloadTaskId,
    );
    if (taskAudioFile != null && taskImage != null) {
      final progressImage = (taskImage.progress / 100) == 1 ? 1 : 0;
      final progress = taskAudioFile.progress + progressImage - 1;
      final taskEpisode = TaskEpisode(
        episodeId: episodePendingDownload.id,
        name: episodePendingDownload.title,
        progress: progress > 0 ? progress : 0,
      );
      tasksEpisode.add(taskEpisode);
    }
  }
  return tasksEpisode;
}
