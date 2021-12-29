import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.thinkerview',
      androidNotificationChannelName: 'Thinkerview',
      androidNotificationOngoing: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  MyAudioHandler() {
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> init(String url) async {
    await _player.setUrl(url);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final extras = mediaItem.extras;
    if (extras != null) {
      await _player.setUrl(extras.entries.first.value.toString());
    }
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
    }
  }
}
