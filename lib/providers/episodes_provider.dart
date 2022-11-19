import 'package:fwp/models/models.dart';
import 'package:fwp/providers/http_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final paginatedEpisodesProvider =
    FutureProvider.autoDispose.family<Episodes, int>((ref, pageIndex) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodes(pageIndex: pageIndex + 1);
});

final episodesCountProvider = Provider.autoDispose((ref) {
  return ref.watch(paginatedEpisodesProvider(1)).whenData((page) => page.total);
});
