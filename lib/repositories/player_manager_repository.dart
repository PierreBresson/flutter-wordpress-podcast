import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final metaDataAudioNotifier = MetaDataAudioNotifier();

  final _audioHandler = getIt<AudioHandler>();
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

  void playEpisode(Episode? episode) {
    final title = episode?.title ?? "";
    final imageUrl = episode?.imageUrl ?? "";

    final artUri = Uri.parse(imageUrl);
    final audioFileUrl = episode?.audioFileUrl ?? "";

    final mediaItem = MediaItem(
      id: title,
      album: packageInfo.appName,
      artUri: artUri,
      title: title,
      extras: {'url': audioFileUrl},
    );

    getIt<DatabaseHandler>().insertEpisodePlayable(
      EpisodePlayable(
        date: episode?.date ?? "",
        id: 0,
        audioFileUrl: audioFileUrl,
        title: title,
        imageUrl: imageUrl,
        positionInSeconds: 0,
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
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;

      getIt<DatabaseHandler>().updateEpisodePlayable(
        EpisodePlayable(
          id: 0,
          date: "",
          audioFileUrl: "",
          title: "",
          imageUrl: "",
          positionInSeconds: position.inSeconds,
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

      final title = mediaItem?.title ?? '';
      final url = mediaItem?.extras?['url'];
      String audioUrl = '';
      if (url != null) {
        audioUrl = mediaItem?.extras?['url'] as String;
      }
      final imageUrl = mediaItem?.artUri.toString() ?? '';

      metaDataAudioNotifier.value = MetaDataAudioState(
        title: title,
        artUri: mediaItem?.artUri ?? Uri(),
      );

      getIt<DatabaseHandler>().insertEpisodePlayable(
        EpisodePlayable(
          date: "",
          id: 0,
          audioFileUrl: audioUrl,
          title: title,
          imageUrl: imageUrl,
          positionInSeconds: 0,
        ),
      );
    });
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void goForward30Seconds() => _audioHandler.customAction('forward');

  void goBackward30Seconds() => _audioHandler.customAction('backward');

  void dispose() => _audioHandler.customAction('dispose');

  void loadEpisodePlayable(EpisodePlayable episodePlayable) =>
      _audioHandler.customAction(
        'loadEpisodePlayable',
        {"episodePlayable": episodePlayable},
      );
}
