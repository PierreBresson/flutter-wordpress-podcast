import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EpisodeOptionsListItemDownloadOfflineEpisode
    extends ConsumerStatefulWidget {
  final Episode episode;
  const EpisodeOptionsListItemDownloadOfflineEpisode({
    super.key,
    required this.episode,
  });

  @override
  EpisodeOptionsListItemDownloadOfflineEpisodeState createState() =>
      EpisodeOptionsListItemDownloadOfflineEpisodeState();
}

class EpisodeOptionsListItemDownloadOfflineEpisodeState
    extends ConsumerState<EpisodeOptionsListItemDownloadOfflineEpisode> {
  late String _localPath;
  late bool _permissionReady;

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        print('TODO failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  void showError(ScaffoldMessengerState scaffold) {
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          LocaleKeys.ui_error.tr(),
        ),
      ),
    );
  }

  Future<void> _prepare() async {
    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
    }
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return EpisodeOptionsListItem(
      iconData: Icons.download,
      text: LocaleKeys.episode_options_widget_download_offline_episode.tr(),
      onTap: () async {
        final navigator = Navigator.of(context);
        final scaffold = ScaffoldMessenger.of(context);
        String? taskIdAudioFileUrl;
        String? taskIdImage;

        try {
          taskIdAudioFileUrl = await FlutterDownloader.enqueue(
            url: fakeEpisodes[0].audioFileUrl,
            savedDir: _localPath,
          );
          taskIdImage = await FlutterDownloader.enqueue(
            url: fakeEpisodes[0].imageUrl,
            savedDir: _localPath,
          );
        } catch (error) {
          if (kDebugMode) {
            print(
                "TODO episode options error FlutterDownloader.enqueue $error");
          }
          showError(scaffold);
          navigator.pop();
          return;
        }

        if (taskIdAudioFileUrl != null && taskIdImage != null) {
          final episodeWithTaskId = widget.episode;
          episodeWithTaskId.audioFileDownloadTaskId = taskIdAudioFileUrl;
          episodeWithTaskId.imageDownloadTaskId = taskIdImage;
          final baseNameAudioFile =
              basename(File(episodeWithTaskId.audioFileUrl).path);
          final baseNameImage = basename(File(episodeWithTaskId.imageUrl).path);

          episodeWithTaskId.audioFilePath = _localPath + baseNameAudioFile;
          episodeWithTaskId.imagePath = _localPath + baseNameImage;

          ref
              .read(offlineEpisodesDownloadPendingStateProvider.notifier)
              .addEpisode(episodeWithTaskId);
        } else {
          print("TODO episode options taskId is null");

          showError(scaffold);
          navigator.pop();
          return;
        }

        navigator.pop();

        scaffold.showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys
                  .episode_options_widget_download_offline_episode_in_progress
                  .tr(),
            ),
          ),
        );
      },
    );
  }
}
