import 'package:flutter/material.dart';

const bool isPlaying = true;

class Player extends StatelessWidget {
  final String imageUrl;
  final String title;

  const Player({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 6,
            width: 40,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Image(image: NetworkImage(imageUrl)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Slider(
            max: 100.0,
            value: 10,
            onChanged: (value) {
              //
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.replay_30,
              size: 50,
            ),
            SizedBox(height: 10),
            Icon(isPlaying ? Icons.pause_sharp : Icons.play_arrow, size: 80),
            SizedBox(height: 10),
            Icon(Icons.forward_30, size: 50)
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
