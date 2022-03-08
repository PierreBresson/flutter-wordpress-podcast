import 'package:audio_service/audio_service.dart';
import 'package:fwp/repositories/audio_handler_repository.dart';
import 'package:fwp/repositories/database_handler.dart';
import 'package:fwp/repositories/player_manager_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<PlayerManager>(() => PlayerManager());
  getIt.registerSingleton<DatabaseHandler>(DatabaseHandler());
}
