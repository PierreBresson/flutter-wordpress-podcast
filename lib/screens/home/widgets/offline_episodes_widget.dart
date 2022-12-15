import 'package:flutter/cupertino.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets/widgets.dart';
import 'package:fwp/selectors/selectors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OfflineEpisodes extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String amountOfDownloads = "";
    final List<Task> tasks = ref.watch(tasksStateProvider);
    final List<Episode> episodesPendingDownload =
        ref.watch(offlineEpisodesDownloadPendingStateProvider);
    final List<TaskEpisode> tasksEpisode = getTaskEpisode(
      episodesPendingDownload: episodesPendingDownload,
      tasks: tasks,
    );
    final currentScreen = ref.watch(offlineDownloadsMenuProvider);

    if (tasksEpisode.isNotEmpty) {
      amountOfDownloads = "(${tasksEpisode.length.toString()})";
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Center(
            child: CupertinoSlidingSegmentedControl<OfflineEpisodesScreens>(
              groupValue: currentScreen,
              onValueChanged: (OfflineEpisodesScreens? value) {
                if (value != null) {
                  ref
                      .read(offlineDownloadsMenuProvider.notifier)
                      .update((state) => value);
                }
              },
              children: <OfflineEpisodesScreens, Widget>{
                OfflineEpisodesScreens.downloaded: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    OfflineEpisodesScreens.downloaded.name,
                  ),
                ),
                OfflineEpisodesScreens.inDownload: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    OfflineEpisodesScreens.inDownload.name + amountOfDownloads,
                  ),
                ),
              },
            ),
          ),
        ),
        if (currentScreen == OfflineEpisodesScreens.downloaded) ...[
          const Expanded(
            child: OfflineEpisodesDownloaded(),
          ),
        ] else ...[
          Expanded(
            child: OfflineEpisodesDownloading(),
          ),
        ],
      ],
    );
  }
}
