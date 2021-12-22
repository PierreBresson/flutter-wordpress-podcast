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
    return Card(
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
                Text(title),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: Row(
                        children: const [
                          Icon(Icons.play_arrow),
                          Text("Play"),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
