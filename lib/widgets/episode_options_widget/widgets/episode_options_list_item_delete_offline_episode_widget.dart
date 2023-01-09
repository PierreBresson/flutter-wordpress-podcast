import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeOptionsListItemDeleteOfflineEpisode extends HookConsumerWidget {
  final Episode episode;
  const EpisodeOptionsListItemDeleteOfflineEpisode({
    super.key,
    required this.episode,
  });

  Future<void> deleteFile(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EpisodeOptionsListItem(
      iconData: Icons.delete_rounded,
      text: LocaleKeys.episode_options_widget_delete_offline_episode.tr(),
      onTap: () async {
        Navigator.pop(context);
        final scaffold = ScaffoldMessenger.of(context);

        try {
          if (episode.audioFilePath == null && episode.imagePath == null) {
            throw Exception("audioFilePath or imagePath is null");
          }

          await deleteFile(File(episode.audioFilePath!));
          await deleteFile(File(episode.imagePath!));
        } catch (error) {
          if (kDebugMode) {
            print(
              "TODO delete episode error ${episode.id.toString()} $error",
            );
          }

          scaffold.showSnackBar(
            SnackBar(
              content: Text(
                LocaleKeys.ui_error.tr(),
              ),
            ),
          );
        }

        ref.read(offlineEpisodesStateProvider.notifier).removeEpisode(episode);

        scaffold.showSnackBar(
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
