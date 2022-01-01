import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String audioFileUrl;
  final VoidCallback onPressed;

  const EpisodeCard({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
    required this.title,
    required this.audioFileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == "" || imageUrl == "" || audioFileUrl == "") {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            SizedBox(
              height: 200.0,
              child: Ink.image(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
