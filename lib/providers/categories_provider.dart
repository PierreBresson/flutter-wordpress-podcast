import 'package:fwp/models/models.dart';
import 'package:fwp/providers/http_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paginatedEpisodesCategoriesProvider =
    FutureProvider.family<EpisodesCategories, int>((ref, pageIndex) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodesCategories(pageIndex: pageIndex + 1);
});

final episodesCategoriesCountProvider = Provider((ref) {
  return ref
      .watch(paginatedEpisodesCategoriesProvider(1))
      .whenData((page) => page.total);
});
