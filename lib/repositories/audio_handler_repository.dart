import 'package:audio_service/audio_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:just_audio/just_audio.dart';

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
  Future<void> playMediaItem(MediaItem newMediaItem) async {
    final url = newMediaItem.extras?.entries.first.value as String;
    queue.add([newMediaItem]);
    mediaItem.add(newMediaItem);

    await _player.setUrl(url);
    _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

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
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future customAction(String action, [Map<String, dynamic>? extras]) async {
    if (action == 'dispose') {
      await _player.dispose();
      super.stop();
    } else if (action == "forward") {
      _player.seek(_player.position + const Duration(seconds: 30));
    } else if (action == "backward") {
      _player.seek(_player.position - const Duration(seconds: 30));
    } else if (action == 'loadEpisodePlayable') {
      final episodePlayable = extras?.entries.first.value as EpisodePlayable;

      final newMediaItem = MediaItem(
        id: episodePlayable.id.toString(),
        album: "",
        artUri: Uri.parse(episodePlayable.imageUrl),
        title: episodePlayable.title,
        extras: {'url': episodePlayable.audioFileUrl},
      );

      queue.add([newMediaItem]);
      mediaItem.add(newMediaItem);

      final Duration position = Duration(
        seconds: episodePlayable.positionInSeconds,
      );

      await _player.setUrl(newMediaItem.extras?['url'] as String);
      await _player.seek(position);
    }
  }
}
