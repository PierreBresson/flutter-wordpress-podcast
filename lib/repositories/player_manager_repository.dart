import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final progressNotifier = ProgressNotifier();
  final playButtonNotifier = PlayButtonNotifier();

  final _audioHandler = getIt<AudioHandler>();

  // Events: Calls coming from the UI
  Future<void> init({String title = "", String audioFileUrl = ""}) async {
    await _loadEpisode(
      title: title,
      audioFileUrl: audioFileUrl,
    );
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
  }

  Future<void> _loadEpisode({
    String title = "",
    String audioFileUrl = "",
  }) async {
    final mediaItem = MediaItem(
      id: title,
      album: "Thinkerview",
      title: title,
      extras: {'url': audioFileUrl},
    );
    _audioHandler.addQueueItem(mediaItem);
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
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
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

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void goForward30Seconds() => _audioHandler.customAction('forward');

  void goBackward30Seconds() => _audioHandler.customAction('backward');

  void dispose() => _audioHandler.customAction('dispose');
}
