import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlayerManager {
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

  Future<void> playEpisode(Episode episode) async {
    final imageUrl = episode.imageUrl;
    final artUri = Uri.parse(imageUrl);

    final mediaItem = MediaItem(
      id: episode.id.toString(),
      album: packageInfo.appName,
      artUri: artUri,
      title: episode.title,
      extras: {
        'url': episode.audioFileUrl,
        'positionInSeconds': episode.positionInSeconds,
      },
    );

    ref
        .read(currentEpisodePlayableProvider.notifier)
        .update((state) => episode);

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

      final Episode? episode = ref.read(currentEpisodePlayableProvider);

      if (episode != null) {
        episode.positionInSeconds = position.inSeconds;

        ref
            .read(currentEpisodePlayableProvider.notifier)
            .update((state) => episode);
        ref
            .read(alreadyPlayedEpisodesStateProvider.notifier)
            .updateEpisode(episode);
      }

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
    });
  }

  Future<void> play() => _audioHandler.play();
  Future<void> pause() => _audioHandler.pause();

  Future<void> seek(Duration position) => _audioHandler.seek(position);

  Future<void> goForward30Seconds() => _audioHandler.customAction('forward');

  Future<void> goBackward30Seconds() => _audioHandler.customAction('backward');

  Future<void> dispose() async => _audioHandler.customAction('dispose');

  Future<void> loadEpisode(Episode episode) => _audioHandler.customAction(
        'loadEpisode',
        {
          "episode": episode,
        },
      );
}
