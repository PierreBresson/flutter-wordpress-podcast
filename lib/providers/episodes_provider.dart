import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final httpProvider = Provider<HttpRepository>((ref) => HttpRepository());

final paginatedEpisodesProvider =
    FutureProvider.autoDispose.family<Episodes, int>((ref, pageIndex) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodes(pageIndex: pageIndex + 1);
});

final episodesCountProvider = Provider.autoDispose((ref) {
  return ref.watch(paginatedEpisodesProvider(1)).whenData((page) => page.total);
});
