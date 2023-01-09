import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeOptionsListItemPlay extends HookConsumerWidget {
  final Episode episode;
  const EpisodeOptionsListItemPlay({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerManager = getIt<PlayerManager>();

    final isOfflineEpisode = ref
        .watch(offlineEpisodesStateProvider.notifier)
        .isOfflineEpisode(episode);

    return EpisodeOptionsListItem(
      iconData: Icons.play_arrow_rounded,
      text: isOfflineEpisode
          ? LocaleKeys.episode_options_widget_play_offline_episode.tr()
          : LocaleKeys.episode_options_widget_play_episode.tr(),
      onTap: () async {
        try {
          final positionInSeconds = ref
              .read(alreadyPlayedEpisodesStateProvider.notifier)
              .getPlaybackPositionInSeconds(episode);

          episode.positionInSeconds = positionInSeconds;

          ref.read(tabIndexProvider.notifier).updateTabIndex(1);
          playerManager.playEpisode(
            episode: episode,
            isOfflineEpisode: isOfflineEpisode,
          );

          Navigator.of(context).maybePop();
        } catch (error) {
          if (kDebugMode) {
            print("TODO play episode error $error");
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.ui_error.tr()),
            ),
          );
        }
      },
    );
  }
}
