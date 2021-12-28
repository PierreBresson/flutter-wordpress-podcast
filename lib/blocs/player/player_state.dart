import 'package:just_audio/just_audio.dart';

class PlayerState {
  ProcessingState processingState = ProcessingState.idle;
  String title;
  String imageUrl;
  String audioFileUrl;

  PlayerState({
    required this.processingState,
    required this.imageUrl,
    required this.title,
    required this.audioFileUrl,
  });
}
