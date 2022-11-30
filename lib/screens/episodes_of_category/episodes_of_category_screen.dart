import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:tuple/tuple.dart';

class EpisodesOfCategory extends HookConsumerWidget {
  final ScrollController scrollController;
  const EpisodesOfCategory({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesCategory = ref.watch(currentEpisodesCategoryProvider);

    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          episodesCategory.name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          episodesCategory.name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: HookConsumer(
        builder: (context, ref, child) {
          final count = ref.watch(
            episodesOfCategoryCountProvider(
              Tuple2<int, int>(0, episodesCategory.id),
            ),
          );

          Future<Episodes> refresh() {
            ref.invalidate(
              paginatedEpisodesOfCategoryProvider(
                Tuple2<int, int>(0, episodesCategory.id),
              ),
            );
            return ref.read(
              paginatedEpisodesOfCategoryProvider(
                Tuple2<int, int>(0, episodesCategory.id),
              ).future,
            );
          }

          return count.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stack) {
              if (kDebugMode) {
                print("TODO count $error $stack");
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
              if (count == 0) {
                return Center(
                  child: Text(
                    LocaleKeys.episodes_of_category_screen_no_episode.tr(),
                  ),
                );
              }
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
                    final pageIndex = index ~/ nbOfEpisodesPerPage;
                    final episodeIndex = index % nbOfEpisodesPerPage;

                    return ProviderScope(
                      overrides: [
                        currentEpisode.overrideWithValue(
                          ref
                              .watch(
                                paginatedEpisodesOfCategoryProvider(
                                  Tuple2<int, int>(
                                    pageIndex,
                                    episodesCategory.id,
                                  ),
                                ),
                              )
                              .whenData(
                                (page) => page.items[episodeIndex],
                              ),
                        ),
                      ],
                      child: EpisodeCardItem(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
