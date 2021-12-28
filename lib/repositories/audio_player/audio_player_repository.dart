import 'package:just_audio/just_audio.dart' as player;

class AudioPlayer {
  static player.AudioPlayer advancedPlayer = player.AudioPlayer();

  Future<void> pause() async {
    try {
      await advancedPlayer.pause();
    } catch (e) {
      // TODO
    }
  }

  Future<void> play() async {
    try {
      await advancedPlayer.play();
    } catch (e) {
      // TODO
    }
  }

  Future<void> stop() async {
    try {
      await advancedPlayer.stop();
    } catch (e) {
      // TODO
    }
  }
}
