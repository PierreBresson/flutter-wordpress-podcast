import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/bottom_sheet_header_widget.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeOptions extends HookConsumerWidget {
  final Episode episode;

  const EpisodeOptions({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext contexts, WidgetRef ref) {
    bool isOfflineEpisode = false;
    final isEpisodeBeingDownloaded = ref
        .watch(offlineEpisodesDownloadPendingStateProvider.notifier)
        .hasEpisode(episode.id);

    if (episode.audioFilePath != null && episode.audioFilePath!.isNotEmpty) {
      isOfflineEpisode = true;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BottomSheetHeader(),
        EpisodeOptionsListItemLaunchArticle(
          episode: episode,
        ),
        EpisodeOptionsListItemCopyPaste(
          episode: episode,
          isCopyArticleUrl: true,
        ),
        EpisodeOptionsListItemCopyPaste(
          episode: episode,
          isCopyArticleUrl: false,
        ),
        EpisodeOptionsListItemMarkAsRead(episode: episode),
        EpisodeOptionsListItemInfo(episode: episode),
        if (isEpisodeBeingDownloaded) ...[
          const SizedBox.shrink()
        ] else if (isOfflineEpisode) ...[
          EpisodeOptionsListItemDeleteOfflineEpisode(episode: episode)
        ] else ...[
          EpisodeOptionsListItemDownloadOfflineEpisode(episode: episode)
        ],
        EpisodeOptionsListItemPlay(
          episode: episode,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
