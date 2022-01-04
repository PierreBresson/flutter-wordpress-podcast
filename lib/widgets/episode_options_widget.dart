import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';

class EpisodeOptions extends StatelessWidget {
  final Episode episode;

  const EpisodeOptions({
    Key? key,
    required this.episode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 6,
            width: 38,
            color: Colors.black38,
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
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
          child: Text(
            "Lire l'épisode",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
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
          child: Text(
            "Copier lien fichier audio",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
