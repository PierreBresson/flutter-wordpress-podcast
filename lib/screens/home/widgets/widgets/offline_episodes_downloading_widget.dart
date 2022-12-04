import 'dart:isolate';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/widgets.dart';

class OfflineEpisodesDownloading extends StatefulWidget {
  const OfflineEpisodesDownloading({
    super.key,
  });

  @override
  OfflineEpisodesDownloadingState createState() =>
      OfflineEpisodesDownloadingState();
}

class OfflineEpisodesDownloadingState
    extends State<OfflineEpisodesDownloading> {
  final ReceivePort _port = ReceivePort();
  List<Task> tasks = [Task(id: "id", name: "Episode 1", progress: 42)];

  void _bindBackgroundIsolate() {
    print("_bindBackgroundIsolate");
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
      print("data $data");
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      final currentTask =
          Task(name: taskId, id: taskId, link: "", progress: progress);

      print(
        'Callback on UI isolate _port.listen: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      final List<Task> newTasks = [];
      for (final task in tasks) {
        if (task.id == taskId) {
          newTasks.add(currentTask);
        } else {
          newTasks.add(task);
        }
      }
      final Task? existingItem = newTasks.firstWhereOrNull(
        (task) => task.id == currentTask.id,
      );

      if (existingItem == null) {
        newTasks.add(currentTask);
      }

      setState(() {
        tasks = newTasks;
      });
      print("_bindBackgroundIsolate tasks $tasks");
      for (final task in tasks) {
        print(task.toString());
      }
      print("_bindBackgroundIsolate newTasks $newTasks");
      for (final task in newTasks) {
        print(task.toString());
      }
      print("end loop tasksss");
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate downloadCallback: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
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
    print("build tasks $tasks");
    for (final task in tasks) {
      print(task.toString());
    }
    print("object");

    if (tasks.isEmpty) {
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
          name: tasks[index].name,
          progress: tasks[index].progress,
          onTap: () {},
        );
      },
      separatorBuilder: (context, _) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: tasks.length,
    );
  }
}
