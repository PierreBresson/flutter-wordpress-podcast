import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/locations.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentEpisodesCategory = Provider<AsyncValue<EpisodesCategory>>((ref) {
  throw UnimplementedError();
});

class EpisodesCategoryItem extends HookConsumerWidget {
  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      border: Border.all(
        width: 0.5,
        color: Theme.of(context).colorScheme.primary,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesCategory = ref.watch(currentEpisodesCategory);

    return episodesCategory.when(
      error: (error, stack) {
        if (kDebugMode) {
          print("TODO episode $error $stack");
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: Text(error.toString())),
        );
      },
      loading: () => const SizedBox.shrink(),
      data: (episodesCategory) {
        return GestureDetector(
          onTap: () {
            ref
                .read(currentEpisodesCategoryProvider.notifier)
                .update((state) => episodesCategory);

            context.beamToNamed(
              homeEpisodesCategoryPath,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10.0),
            decoration: myBoxDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    episodesCategory.name,
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
