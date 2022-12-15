import 'package:flutter/cupertino.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets/widgets.dart';
import 'package:fwp/selectors/selectors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum EpisodesTabs { downloaded, inDownload }

class OfflineEpisodes extends ConsumerStatefulWidget {
  const OfflineEpisodes({
    super.key,
  });

  @override
  OfflineEpisodesState createState() => OfflineEpisodesState();
}

class OfflineEpisodesState extends ConsumerState<OfflineEpisodes> {
  EpisodesTabs _selectedSegment = EpisodesTabs.downloaded;

  @override
  Widget build(BuildContext context) {
    String amountOfDownloads = "";
    final List<Task> tasks = ref.watch(tasksStateProvider);
    final List<Episode> episodesPendingDownload =
        ref.watch(offlineEpisodesDownloadPendingStateProvider);
    final List<TaskEpisode> tasksEpisode = getTaskEpisode(
      episodesPendingDownload: episodesPendingDownload,
      tasks: tasks,
    );

    if (tasksEpisode.isNotEmpty) {
      amountOfDownloads = "(${tasksEpisode.length.toString()})";
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Center(
            child: CupertinoSlidingSegmentedControl<EpisodesTabs>(
              groupValue: _selectedSegment,
              onValueChanged: (EpisodesTabs? value) {
                if (value != null) {
                  setState(() {
                    _selectedSegment = value;
                  });
                }
              },
              children: <EpisodesTabs, Widget>{
                EpisodesTabs.downloaded: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.offline_episodes_widget_downloaded.tr(),
                  ),
                ),
                EpisodesTabs.inDownload: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.offline_episodes_widget_in_download.tr() +
                        amountOfDownloads,
                  ),
                ),
              },
            ),
          ),
        ),
        if (_selectedSegment == EpisodesTabs.downloaded) ...[
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
