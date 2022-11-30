import 'package:fwp/models/models.dart';
import 'package:fwp/providers/http_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paginatedEpisodesProvider =
    FutureProvider.family<Episodes, int>((ref, pageIndex) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodes(pageIndex: pageIndex + 1);
});

final episodesCountProvider = Provider((ref) {
  return ref.watch(paginatedEpisodesProvider(0)).whenData((page) => page.total);
});
