import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';

class EpisodeOptionsListItemCopyPaste extends StatelessWidget {
  final Episode episode;
  final bool isCopyArticleUrl;
  const EpisodeOptionsListItemCopyPaste({
    super.key,
    required this.episode,
    required this.isCopyArticleUrl,
  });

  @override
  Widget build(BuildContext context) {
    return EpisodeOptionsListItem(
      iconData: Icons.copy,
      text: isCopyArticleUrl
          ? LocaleKeys.episode_options_widget_copy_article_link.tr()
          : LocaleKeys.episode_options_widget_copy_audio_link.tr(),
      onTap: () {
        Navigator.pop(context);
        Clipboard.setData(
          ClipboardData(
            text: isCopyArticleUrl ? episode.articleUrl : episode.audioFileUrl,
          ),
        ).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                LocaleKeys.episode_options_widget_link_was_copied.tr(),
              ),
            ),
          );
        });
      },
    );
  }
}
