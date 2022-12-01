import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeOptionsListItemLaunchArticle extends StatelessWidget {
  final Episode episode;
  const EpisodeOptionsListItemLaunchArticle({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context) {
    return EpisodeOptionsListItem(
      iconData: Icons.link,
      text: LocaleKeys.episode_options_widget_open_article_in_browser.tr(),
      onTap: () {
        Navigator.pop(context);
        launchUrl(
          Uri.parse(episode.articleUrl),
        );
      },
    );
  }
}
