import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<AudioHandler> initAudioService() async {
  final String app = dotenv.env['APP']!;

  return AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: app,
      androidNotificationChannelName: app,
      androidNotificationOngoing: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  PackageInfo packageInfo =
      PackageInfo(appName: "", packageName: "", version: "", buildNumber: "");

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.rewind,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.fastForward,
          ],
          systemActions: const {
            MediaAction.seek,
          },
          androidCompactActionIndices: const [0, 1, 3],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
        ),
      );
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      final index = _player.currentIndex;
      if (index == null || queue.value.isEmpty) return;
      final newMediaItem = queue.value[index].copyWith(duration: duration);
      mediaItem.add(newMediaItem);
    });
  }

  @override
  Future<void> fastForward() async {
    _player.seek(_player.position + const Duration(seconds: 10));
  }

  @override
  Future<void> rewind() async {
    _player.seek(_player.position - const Duration(seconds: 10));
  }

  @override
  Future<void> onNotificationDeleted() async {
    super.stop();
    await _player.dispose();
  }

  @override
  Future<void> playMediaItem(MediaItem newMediaItem) async {
    final path = newMediaItem.extras?.entries.first.value as String;
    final positionInSeconds = newMediaItem.extras?.entries.last.value as int;
    queue.add([newMediaItem]);
    mediaItem.add(newMediaItem);
    final isLocalFile = true;

    if (_player.playing) {
      await _player.stop();
    }

    try {
      if (isLocalFile) {
        await _player.setAsset(path);
      } else {
        await _player.setUrl(path);
      }
    } on PlayerException catch (error) {
      if (kDebugMode) {
        print("TODO audioHandler : Error code: ${error.code}");
        print("TODO audioHandler : Error message: ${error.message}");
      }
    } on PlayerInterruptedException catch (error) {
      if (kDebugMode) {
        print("TODO audioHandler : Connection aborted: ${error.message}");
      }
    } catch (error) {
      if (kDebugMode) {
        print('TODO audioHandler : An error occured: $error');
      }
    }

    _player.play();

    if (positionInSeconds != 0) {
      try {
        await _player.seek(Duration(seconds: positionInSeconds));
      } catch (error) {
        if (kDebugMode) {
          print('TODO audioHandler : An error occured seek: $error');
        }
      }
    }
  }

  @override
  Future<void> play() {
    return _player.play();
  }

  @override
  Future<void> pause() {
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    // Set the audio_service state to `idle` to deactivate the notification.
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
      ),
    );
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }

  @override
  Future customAction(String action, [Map<String, dynamic>? extras]) async {
    const seekDuration = 30;

    if (action == "dispose") {
      super.stop();
      await _player.dispose();
    } else if (action == "forward") {
      final int position = _player.position.inSeconds;
      final int? duration = _player.duration?.inSeconds;
      if (duration != null) {
        if (position + seekDuration < duration) {
          _player
              .seek(_player.position + const Duration(seconds: seekDuration));
        }
      }
    } else if (action == "backward") {
      final position = _player.position;
      if (position.inSeconds > seekDuration) {
        _player.seek(_player.position - const Duration(seconds: seekDuration));
      }
    } else if (action == "loadEpisode") {
      final episode = extras?.entries.first.value as Episode;

      final newMediaItem = MediaItem(
        id: episode.id.toString(),
        album: packageInfo.appName,
        artUri: Uri.parse(episode.imageUrl),
        title: episode.title,
        extras: {
          'url': episode.audioFileUrl,
        },
      );

      queue.add([newMediaItem]);
      mediaItem.add(newMediaItem);

      final Duration position = Duration(
        seconds: episode.positionInSeconds,
      );

      await _player.setUrl(newMediaItem.extras?['url'] as String);
      await _player.seek(position);
    }
  }
}
