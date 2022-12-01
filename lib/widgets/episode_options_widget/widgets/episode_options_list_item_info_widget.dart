import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/locations.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/episode_options_widget/widgets/episode_options_list_item_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeOptionsListItemInfo extends HookConsumerWidget {
  final Episode episode;
  final app = dotenv.env['APP'];
  EpisodeOptionsListItemInfo({
    super.key,
    required this.episode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EpisodeOptionsListItem(
      iconData: Icons.info_sharp,
      text: LocaleKeys.episode_options_widget_more_info_on_episode.tr(),
      onTap: () async {
        Navigator.pop(context);
        ref.read(episodeSelectedProvider.notifier).update((state) => episode);

        if (app == APP.thinkerview.name) {
          context.beamToNamed(homeCaptainFactPath);
        } else {
          final state =
              Beamer.of(context).currentBeamLocation.state as BeamState?;

          if (state != null) {
            if (state.pathPatternSegments.contains(episodesCategoryPath)) {
              context.beamToNamed(
                homeEpisodesCategoryArticlePath,
              );
            } else {
              context.beamToNamed(homeArticlePath);
            }
          }
        }
      },
    );
  }
}
