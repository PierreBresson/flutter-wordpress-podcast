import 'package:fwp/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final episodesCategorySelectedProvider = StateProvider<EpisodesCategory>(
  (ref) => EpisodesCategory(id: 0, name: ""),
);
