import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/screens.dart';
import 'package:fwp/styles/styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

const paddingItems = 18.0;

class ListItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;
  const ListItem({
    Key? key,
    required this.iconData,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(
        iconData,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}

class EpisodeOptions extends ConsumerWidget {
  final Episode episode;
  final app = dotenv.env['APP'];

  EpisodeOptions({
    Key? key,
    required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerManager = getIt<PlayerManager>();
    final isDarkMode = isAppInDarkMode(context);
    final hasBeenPlayed =
        ref.watch(playedEpisodesStateProvider).contains(episode.id);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 5,
              width: 42,
              color: isDarkMode ? Colors.grey : Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ListItem(
          iconData: Icons.link,
          text: LocaleKeys.episode_options_widget_open_article_in_browser.tr(),
          onTap: () {
            Navigator.pop(context);
            launchUrl(
              Uri.parse(episode.articleUrl),
            );
          },
        ),
        ListItem(
          iconData: Icons.copy,
          text: LocaleKeys.episode_options_widget_copy_article_link.tr(),
          onTap: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: episode.articleUrl))
                .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      LocaleKeys.episode_options_widget_link_was_copied.tr()),
                ),
              );
            });
          },
        ),
        ListItem(
          iconData: Icons.copy,
          text: LocaleKeys.episode_options_widget_copy_audio_link.tr(),
          onTap: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: episode.audioFileUrl))
                .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      LocaleKeys.episode_options_widget_link_was_copied.tr()),
                ),
              );
            });
          },
        ),
        ListItem(
          iconData: Icons.check_circle,
          text: hasBeenPlayed
              ? LocaleKeys.episode_options_widget_mark_as_not_read.tr()
              : LocaleKeys.episode_options_widget_mark_as_read.tr(),
          onTap: () {
            if (hasBeenPlayed) {
              ref
                  .read(playedEpisodesStateProvider.notifier)
                  .removePlayedEpisode(episode.id);
            } else {
              ref
                  .read(playedEpisodesStateProvider.notifier)
                  .addPlayedEpisode(episode.id);
            }
            Navigator.pop(context);
          },
        ),
        ListItem(
          iconData: Icons.info_sharp,
          text: LocaleKeys.episode_options_widget_more_info_on_episode.tr(),
          onTap: () async {
            Navigator.pop(context);
            if (app == APP.thinkerview.name) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodeDetailsCaptainFact(
                    episode: episode,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodeDetails(
                    episode: episode,
                  ),
                ),
              );
            }
          },
        ),
        ListItem(
          iconData: Icons.play_arrow_rounded,
          text: LocaleKeys.episode_options_widget_play_episode.tr(),
          onTap: () async {
            try {
              final positionInSeconds = ref
                  .read(alreadyPlayedEpisodesStateProvider.notifier)
                  .getPlaybackPositionInSeconds(episode);

              episode.positionInSeconds = positionInSeconds;

              ref
                  .read(currentEpisodePlayableProvider.notifier)
                  .update((state) => episode);

              ref.read(tabIndexProvider.notifier).update((state) => 1);
              playerManager.playEpisode(episode);

              Navigator.pop(context);
            } catch (error) {
              if (kDebugMode) {
                print("TODO error play episode $error");
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.ui_error.tr()),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
