import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class EpisodesOfCategory extends StatelessWidget {
  final ScrollController scrollController;
  const EpisodesOfCategory({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final EpisodesCategory episodesCategory =
        Beamer.of(context).currentBeamLocation.data! as EpisodesCategory;

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
              PaginationIndexAndCategoryId(
                categoryId: episodesCategory.id,
                pageIndex: 0,
              ),
            ),
          );

          Future<Episodes> refresh() {
            ref.invalidate(
              paginatedEpisodesOfCategoryProvider(
                PaginationIndexAndCategoryId(
                  categoryId: episodesCategory.id,
                  pageIndex: 0,
                ),
              ),
            );
            return ref.read(
              paginatedEpisodesOfCategoryProvider(
                PaginationIndexAndCategoryId(
                  categoryId: episodesCategory.id,
                  pageIndex: 0,
                ),
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
              print("inside $count");
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
                                paginatedEpisodesProvider(
                                  pageIndex ~/ nbOfEpisodesPerPage,
                                ),
                              )
                              .whenData(
                                (page) => page
                                    .items[episodeIndex % nbOfEpisodesPerPage],
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
