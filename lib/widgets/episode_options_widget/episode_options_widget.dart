import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/bottom_sheet_header_widget.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/widgets.dart';

class EpisodeOptions extends StatelessWidget {
  final Episode episode;

  const EpisodeOptions({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext contexts) {
    bool isOfflineEpisode = false;

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
        if (isOfflineEpisode) ...[
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