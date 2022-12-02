import 'package:flutter_downloader/flutter_downloader.dart';

class Task {
  final String id;
  final String? name;
  final String? link;
  final int? progress;
  final DownloadTaskStatus? status;

  Task({
    required this.id,
    this.name,
    this.link,
    this.progress = 0,
    this.status = DownloadTaskStatus.undefined,
  });
}
