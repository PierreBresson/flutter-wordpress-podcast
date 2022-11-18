import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/episode_model.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class HomeScreen extends HookConsumerWidget {
  final ScrollController scrollController;
  const HomeScreen({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          "Derniers épisodes",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Derniers épisodes",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: HookConsumer(
        builder: (context, ref, child) {
          final count = ref.watch(episodesCountProvider);

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
                print("TODO count $error $stack");
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Une erreur est survenue'),
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
                      label: const Text("Essayer à nouveau"),
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
                    final pageIndex = index ~/ nbOfEpisodesPerPage;
                    final episodeIndex = index % nbOfEpisodesPerPage;

                    return ProviderScope(
                      overrides: [
                        currentEpisode.overrideWithValue(
                          ref
                              .watch(
                                paginatedEpisodesProvider(
                                  pageIndex,
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
