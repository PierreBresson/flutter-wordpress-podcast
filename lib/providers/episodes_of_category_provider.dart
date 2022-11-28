import 'package:fwp/models/models.dart';
import 'package:fwp/providers/http_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

final FutureProviderFamily<Episodes, Tuple2<int, int>>
    paginatedEpisodesOfCategoryProvider =
    FutureProvider.family<Episodes, Tuple2<int, int>>((ref, item) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodesFromCategory(
    pageIndex: item.item1 + 1,
    categoryId: item.item2,
  );
});

final ProviderFamily<AsyncValue<int>, Tuple2<int, int>>
    episodesOfCategoryCountProvider =
    Provider.family<AsyncValue<int>, Tuple2<int, int>>((ref, item) {
  return ref
      .watch(
        paginatedEpisodesOfCategoryProvider(item.withItem1(1)),
      )
      .whenData((page) => page.total);
});
