import 'package:bloc/bloc.dart';
import 'package:fwp/models/models.dart';
import './player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit()
      : super(
          PlayerState(
            imageUrl: "",
            title: "",
            audioFileUrl: "",
          ),
        );

  Future<void> playEpisode(Episode episode) async {
    emit(
      PlayerState(
        audioFileUrl: episode.audioFileUrl,
        imageUrl: episode.imageUrl,
        title: episode.title,
      ),
    );
  }
}
