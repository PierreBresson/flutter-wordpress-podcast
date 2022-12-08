import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeOptionsListItemMarkAsRead extends HookConsumerWidget {
  final Episode episode;
  const EpisodeOptionsListItemMarkAsRead({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasBeenPlayed =
        ref.watch(playedEpisodesStateProvider).contains(episode.id);

    return EpisodeOptionsListItem(
      iconData: Icons.check_circle,
      text: hasBeenPlayed
          ? LocaleKeys.episode_options_widget_mark_as_not_read.tr()
          : LocaleKeys.episode_options_widget_mark_as_read.tr(),
      onTap: () {
        if (hasBeenPlayed) {
          ref
              .read(playedEpisodesStateProvider.notifier)
              .removeEpisode(episode.id);
        } else {
          ref.read(playedEpisodesStateProvider.notifier).addEpisode(episode.id);
        }
        Navigator.pop(context);
      },
    );
  }
}
