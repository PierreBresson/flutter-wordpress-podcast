import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineDownloadWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const OfflineDownloadWrapper({
    super.key,
    required this.child,
  });

  @override
  OfflineEpisodesDownloadingState createState() =>
      OfflineEpisodesDownloadingState();
}

class OfflineEpisodesDownloadingState
    extends ConsumerState<OfflineDownloadWrapper> {
  final ReceivePort _port = ReceivePort();

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      final task = Task(
        name: taskId,
        id: taskId,
        progress: progress,
        status: status,
      );

      ref.read(tasksStateProvider.notifier).updateTask(task);
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  void loadPreviousTasks() {
    // final tasks = await FlutterDownloader.loadTasks();
    resumePreviousTasks();
  }

  void resumePreviousTasks() {
    //
  }

  void taskListener() {
    ref.read(tasksStateProvider.notifier).addListener((state) {
      final List<Episode> episodes =
          ref.read(offlineEpisodesDownloadPendingStateProvider);

      for (final episode in episodes) {
        final taskAudioFile = state.firstWhereOrNull(
          (task) => task.id == episode.audioFileDownloadTaskId,
        );
        final taskImage = state.firstWhereOrNull(
          (task) => task.id == episode.imageDownloadTaskId,
        );

        print("titi");
        if (taskAudioFile != null && taskImage != null) {
          print("toto");
          print(taskAudioFile.status);
          print(taskImage.status);
          print("toto end");
          if (taskAudioFile.status == DownloadTaskStatus.complete &&
              taskImage.status == DownloadTaskStatus.complete) {
            print("tata");
            ref.read(offlineEpisodesStateProvider.notifier).addEpisode(episode);
            ref.read(tasksStateProvider.notifier).removeTask(taskAudioFile);
            ref.read(tasksStateProvider.notifier).removeTask(taskImage);
            ref
                .read(offlineEpisodesDownloadPendingStateProvider.notifier)
                .removeEpisodeById(episode);
          }

          if (taskAudioFile.status == DownloadTaskStatus.failed &&
              taskImage.status == DownloadTaskStatus.failed) {
            ref.read(tasksStateProvider.notifier).removeTask(taskAudioFile);
            ref.read(tasksStateProvider.notifier).removeTask(taskImage);
            ref
                .read(offlineEpisodesDownloadPendingStateProvider.notifier)
                .removeEpisodeById(episode);
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    loadPreviousTasks();
    taskListener();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
