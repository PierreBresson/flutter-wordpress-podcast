import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';

class EpisodeOptionsListItemDeleteOfflineEpisode extends StatelessWidget {
  final Episode episode;
  const EpisodeOptionsListItemDeleteOfflineEpisode({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return EpisodeOptionsListItem(
      iconData: Icons.delete_rounded,
      text: LocaleKeys.episode_options_widget_delete_offline_episode.tr(),
      onTap: () {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.episode_options_widget_delete_offline_episode_sucess
                  .tr(),
            ),
          ),
        );
      },
    );
  }
}
