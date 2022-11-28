import 'package:fwp/models/models.dart';
import 'package:fwp/providers/http_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaginationIndexAndCategoryId {
  final int pageIndex;
  final int categoryId;

  PaginationIndexAndCategoryId({
    required this.pageIndex,
    required this.categoryId,
  });
}

final initValue = PaginationIndexAndCategoryId(categoryId: 0, pageIndex: 0);

final FutureProviderFamily<Episodes, PaginationIndexAndCategoryId>
    paginatedEpisodesOfCategoryProvider =
    FutureProvider.family<Episodes, PaginationIndexAndCategoryId>(
        (ref, paginationAndCategoryId) async {
  final http = ref.watch(httpProvider);
  return http.getEpisodesFromCategory(
    pageIndex: paginationAndCategoryId.pageIndex,
    categoryId: paginationAndCategoryId.categoryId,
  );
});

final ProviderFamily<AsyncValue<int>, PaginationIndexAndCategoryId>
    episodesOfCategoryCountProvider =
    Provider.family<AsyncValue<int>, PaginationIndexAndCategoryId>(
        (ref, paginationIndexAndCategoryId) {
  return ref
      .watch(
        paginatedEpisodesOfCategoryProvider(initValue),
      )
      .whenData((page) => page.total);
});
