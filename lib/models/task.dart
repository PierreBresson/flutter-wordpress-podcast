import 'package:flutter_downloader/flutter_downloader.dart';

class Task {
  final String id;
  final String name;
  final int progress;
  final DownloadTaskStatus? status;

  Task({
    required this.id,
    required this.name,
    this.progress = 0,
    this.status = DownloadTaskStatus.undefined,
  });

  @override
  String toString() {
    return 'Task{id: $id, name: $name, progress: $progress, status: $status }';
  }
}
