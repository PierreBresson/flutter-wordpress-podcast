import 'package:fwp/models/models.dart';
import 'package:riverpod/riverpod.dart';

final currentEpisodePlayableProvider =
    StateProvider<EpisodePlayable?>((ref) => null);