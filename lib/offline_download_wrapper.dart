import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
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

      final task = Task(name: taskId, id: taskId, link: "", progress: progress);

      if (status == DownloadTaskStatus.complete) {
        ref.read(tasksStateProvider.notifier).removeTask(task);
      } else {
        ref.read(tasksStateProvider.notifier).updateTask(task);
      }
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

  removeFinished() {
    final toto = ref.read(tasksStateProvider.notifier).addListener((state) {});
    //         final episode = ref
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
  }

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    loadPreviousTasks();
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
