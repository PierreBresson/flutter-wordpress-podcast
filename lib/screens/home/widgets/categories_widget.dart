import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/episode_model.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Categories extends StatelessWidget {
  final ScrollController scrollController;
  const Categories({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final count = ref.watch(episodesCategoriesCountProvider);

        Future<Episodes> refresh() {
          ref.refresh(paginatedEpisodesProvider(0));
          return ref.read(paginatedEpisodesProvider(0).future);
        }

        return count.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) {
            if (kDebugMode) {
              print("TODO categories widget count error: $error $stack");
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.ui_error.tr()),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: refresh,
                    label: Text(LocaleKeys.ui_try_again.tr()),
                  )
                ],
              ),
            );
          },
          data: (count) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.separated(
                controller: scrollController,
                separatorBuilder: (context, _) {
                  return const SizedBox(
                    height: 2,
                  );
                },
                itemCount: count,
                itemBuilder: (context, index) {
                  final pageIndex = index ~/ nbOfEpisodesCategoriesPerPage;
                  final categoryIndex = index % nbOfEpisodesCategoriesPerPage;

                  return ProviderScope(
                    overrides: [
                      currentEpisodesCategory.overrideWithValue(
                        ref
                            .watch(
                              paginatedEpisodesCategoriesProvider(
                                pageIndex,
                              ),
                            )
                            .whenData(
                              (page) => page.items[categoryIndex],
                            ),
                      ),
                    ],
                    child: EpisodesCategoryItem(),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
