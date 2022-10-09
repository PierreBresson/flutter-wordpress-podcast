import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
          text: "Ouvrir article dans navigateur",
          onTap: () {
            Navigator.pop(context);
            launchUrl(
              Uri.parse(episode.articleUrl),
            );
          },
        ),
        ListItem(
          iconData: Icons.copy,
          text: "Copier lien article",
          onTap: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: episode.articleUrl))
                .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Le lien a été copié dans le presse-papiers"),
                ),
              );
            });
          },
        ),
        ListItem(
          iconData: Icons.copy,
          text: "Copier lien fichier audio",
          onTap: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: episode.audioFileUrl))
                .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Le lien a été copié dans le presse-papiers"),
                ),
              );
            });
          },
        ),
        ListItem(
          iconData: Icons.info_sharp,
          text: "Plus d'info sur l'épisode",
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
          text: "Lire l'épisode",
          onTap: () async {
            try {
              final EpisodePlayable episodePlayable = EpisodePlayable(
                id: episode.id,
                articleUrl: episode.articleUrl,
                audioFileUrl: episode.audioFileUrl,
                date: episode.date,
                title: episode.title,
                description: episode.description,
                imageUrl: episode.imageUrl,
              );
              ref
                  .read(currentEpisodePlayableProvider.notifier)
                  .update((state) => episodePlayable);

              ref.read(tabIndexProvider.notifier).update((state) => 1);
              playerManager.playEpisode(episodePlayable);

              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Une erreur est survenue"),
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
