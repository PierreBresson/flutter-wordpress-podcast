import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final metaDataAudioNotifier = MetaDataAudioNotifier();
  final _audioHandler = getIt<AudioHandler>();
  late WidgetRef ref;

  PackageInfo packageInfo =
      PackageInfo(appName: "", packageName: "", version: "", buildNumber: "");

  // Events: Calls coming from the UI
  Future<void> init() async {
    packageInfo = await PackageInfo.fromPlatform();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    _listenToChangesInPlaylist();
  }

  void playEpisode(EpisodePlayable episodePlayble) {
    final imageUrl = episodePlayble.imageUrl;
    final artUri = Uri.parse(imageUrl);

    final mediaItem = MediaItem(
      id: episodePlayble.title,
      album: packageInfo.appName,
      artUri: artUri,
      title: episodePlayble.title,
      extras: {
        'url': episodePlayble.audioFileUrl,
        'articleUrl': episodePlayble.articleUrl,
        'description': episodePlayble.description,
      },
    );

    ref.read(currentEpisodePlayableProvider.notifier).update(
          (EpisodePlayable? state) => state == null
              ? null
              : EpisodePlayable(
                  date: episodePlayble.date,
                  id: episodePlayble.id,
                  audioFileUrl: episodePlayble.audioFileUrl,
                  articleUrl: episodePlayble.articleUrl,
                  title: episodePlayble.title,
                  imageUrl: episodePlayble.imageUrl,
                  description: episodePlayble.description,
                  isPlaying: true,
                  positionInSeconds: episodePlayble.positionInSeconds,
                  hasBeenFullyPlayed: episodePlayble.hasBeenFullyPlayed,
                  imageDownloadTaskId: episodePlayble.imageDownloadTaskId,
                  imagePath: episodePlayble.imagePath,
                  audioFileDownloadTaskId:
                      episodePlayble.audioFileDownloadTaskId,
                  audioFilePath: episodePlayble.audioFilePath,
                ),
        );

    _audioHandler.playMediaItem(mediaItem);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        currentSongTitleNotifier.value = '';
      }

      metaDataAudioNotifier.value = MetaDataAudioState(
        title: '',
        artUri: Uri(),
      );
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((Duration position) {
      final oldState = progressNotifier.value;

      ref.read(currentEpisodePlayableProvider.notifier).update(
            (EpisodePlayable? state) => state == null
                ? null
                : EpisodePlayable(
                    id: state.id,
                    date: state.date,
                    audioFileUrl: state.audioFileUrl,
                    articleUrl: state.articleUrl,
                    title: state.title,
                    imageUrl: state.imageUrl,
                    description: state.description,
                    positionInSeconds: position.inSeconds,
                    hasBeenFullyPlayed: state.hasBeenFullyPlayed,
                    imageDownloadTaskId: state.imageDownloadTaskId,
                    imagePath: state.imagePath,
                    audioFileDownloadTaskId: state.audioFileDownloadTaskId,
                    audioFilePath: state.audioFilePath,
                  ),
          );

      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((PlaybackState playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';

      //// TODO: CHECK THAT THIS CODE BELOW IS ACTUALLY DOING SOMETHING, BOTH IOS/ANDROID
      final title = mediaItem?.title ?? '';

      metaDataAudioNotifier.value = MetaDataAudioState(
        title: title,
        artUri: mediaItem?.artUri ?? Uri(),
      );

      // final id = mediaItem?.extras?['id'];
      // int idProcessed = 0;
      // if (id != null) {
      //   idProcessed = mediaItem?.extras?['id'] as int;
      // }

      // final audioFileUrl = mediaItem?.extras?['url'];
      // String audioFileUrlProcessed = '';
      // if (audioFileUrl != null) {
      //   audioFileUrlProcessed = mediaItem?.extras?['url'] as String;
      // }

      // final articleUrl = mediaItem?.extras?['articleUrl'];
      // String articleUrlProcessed = '';
      // if (articleUrl != null) {
      //   articleUrlProcessed = mediaItem?.extras?['articleUrl'] as String;
      // }

      // final description = mediaItem?.extras?['description'];
      // String descriptionProcessed = '';
      // if (description != null) {
      //   descriptionProcessed = mediaItem?.extras?['description'] as String;
      // }

      // final bool? hasBeenFullyPlayed =
      //     mediaItem?.extras?['hasBeenFullyPlayed'] as bool?;
      // final String? imagePath = mediaItem?.extras?['imagePath'] as String?;
      // final String? audioFilePath =
      //     mediaItem?.extras?['audioFilePath'] as String?;
      // final String? imageDownloadTaskId =
      //     mediaItem?.extras?['imageDownloadTaskId'] as String?;
      // final String? audioFileDownloadTaskId =
      //     mediaItem?.extras?['audioFileDownloadTaskId'] as String?;

      // final imageUrl = mediaItem?.artUri.toString() ?? '';

      // getIt<DatabaseHandler>().insertEpisodePlayable(
      //   EpisodePlayable(
      //     date: "",
      //     id: idProcessed,
      //     audioFileUrl: audioFileUrlProcessed,
      //     articleUrl: articleUrlProcessed,
      //     description: descriptionProcessed,
      //     title: title,
      //     imageUrl: imageUrl,
      //     positionInSeconds: 0,
      //     isPlaying: true,
      //     hasBeenFullyPlayed: hasBeenFullyPlayed,
      //     imagePath: imagePath,
      //     audioFilePath: audioFilePath,
      //     imageDownloadTaskId: imageDownloadTaskId,
      //     audioFileDownloadTaskId: audioFileDownloadTaskId,
      //   ),
      // );
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void goForward30Seconds() => _audioHandler.customAction('forward');

  void goBackward30Seconds() => _audioHandler.customAction('backward');

  Future<void> dispose() async => _audioHandler.customAction('dispose');

  void loadEpisodePlayable(EpisodePlayable episodePlayable) =>
      _audioHandler.customAction(
        'loadEpisodePlayable',
        {
          "episodePlayable": episodePlayable,
        },
      );
}
