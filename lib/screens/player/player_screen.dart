import 'package:flutter/material.dart';

const bool isPlaying = true;

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Image(image: NetworkImage("imageUrl")),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "pppp",
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
      ),
    );
  }
}
