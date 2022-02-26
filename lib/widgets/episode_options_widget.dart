import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/screens.dart';
import 'package:url_launcher/url_launcher.dart';

const paddingItems = 18.0;

class EpisodeOptions extends StatelessWidget {
  final Episode episode;
  final app = dotenv.env['APP'];

  EpisodeOptions({
    Key? key,
    required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              width: 38,
              color: Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ListTile(
          title: Text(
            "Ouvrir article dans navigateur",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: Icon(
            Icons.link,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () {
            Navigator.pop(context);
            launch(episode.articleUrl);
          },
        ),
        ListTile(
          title: Text(
            "Copier lien article",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: Icon(
            Icons.copy,
            color: Theme.of(context).colorScheme.primary,
          ),
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
        ListTile(
          title: Text(
            "Copier lien fichier audio",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.left,
          ),
          leading: Icon(
            Icons.copy,
            color: Theme.of(context).colorScheme.primary,
          ),
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
        ListTile(
          title: Text(
            "Plus d'info sur l'épisode",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: Icon(
            Icons.info_sharp,
            color: Theme.of(context).colorScheme.primary,
          ),
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
        ListTile(
          title: Text(
            "Lire l'épisode",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: Icon(
            Icons.play_arrow_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () async {
            try {
              playerManager.playEpisode(episode);
              Navigator.pop(context);
              context.read<BottomBarNavigationCubit>().update(1);
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
