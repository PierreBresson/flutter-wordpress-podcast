import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineEpisodes extends ConsumerStatefulWidget {
  const OfflineEpisodes({
    super.key,
  });

  @override
  OfflineEpisodesState createState() => OfflineEpisodesState();
}

class OfflineEpisodesState extends ConsumerState<OfflineEpisodes> {
  final ReceivePort _port = ReceivePort();
  List<Task> tasks = [];

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
      print(data);
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;
      final currentTask =
          Task(name: taskId, id: taskId, link: "", progress: progress);

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (tasks.isNotEmpty) {
        final List<Task> newTasks = [];
        for (final task in tasks) {
          if (task.id == taskId) {
            newTasks.add(currentTask);
          } else {
            newTasks.add(task);
          }
        }
        setState(() {
          tasks = newTasks;
        });
      } else {
        setState(() {
          tasks = [];
        });
      }
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
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
    final episodes = ref.watch(offlineEpisodesStateProvider);

    if (episodes.isEmpty) {
      return Center(
        child: Text(LocaleKeys.offline_episodes_widget_no_offline_episode.tr()),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        return Text(tasks[index].id);
      },
      separatorBuilder: (context, _) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: tasks.length,
    );
    // ListView.separated(
    //   separatorBuilder: (context, _) {
    //     return const SizedBox(
    //       height: 2,
    //     );
    //   },
    //   itemCount: episodes.length,
    //   itemBuilder: (context, index) {
    //     return EpisodeCard(episode: episodes[index]);
    //   },
    // ),
  }
}
