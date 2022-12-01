import 'package:fwp/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final episodeSelectedProvider = StateProvider<Episode>(
  (ref) => Episode(
    id: 0,
    audioFileUrl: "",
    articleUrl: "",
    date: "",
    title: "",
    imageUrl: "",
    description: "",
  ),
);
