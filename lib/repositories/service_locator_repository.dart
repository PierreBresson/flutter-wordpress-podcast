import 'package:get_it/get_it.dart';
import './player_manager_repository.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<PlayerManager>(() => PlayerManager());
}
