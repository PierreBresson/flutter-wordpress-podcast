import 'package:bloc/bloc.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import './player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final AudioPlayer _audioPlayer;

  PlayerCubit({
    required AudioPlayer audioPlayer,
  })  : _audioPlayer = audioPlayer,
        super(
          PlayerState(
            processingState: just_audio.ProcessingState.idle,
            imageUrl: "",
            title: "",
            audioFileUrl: "",
          ),
        ) {
    //
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      //TODO
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      // TODO
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      // TODO
    }
  }
}
