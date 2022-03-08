import 'package:flutter/material.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';

const iconSize = 50.0;

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: iconSize,
            onPressed: () {
              if (playerManager.currentSongTitleNotifier.value.isNotEmpty) {
                playerManager.goBackward30Seconds();
              }
            },
            icon: const Icon(
              Icons.replay_30,
            ),
          ),
          const PlayButton(),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            iconSize: iconSize,
            onPressed: () {
              if (playerManager.currentSongTitleNotifier.value.isNotEmpty) {
                playerManager.goForward30Seconds();
              }
            },
            icon: const Icon(
              Icons.forward_30,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return ValueListenableBuilder<ButtonState>(
      valueListenable: playerManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: iconSize,
              height: iconSize,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.play_arrow),
              iconSize: iconSize,
              onPressed: () {
                if (playerManager.currentSongTitleNotifier.value.isNotEmpty) {
                  playerManager.play();
                }
              },
            );
          case ButtonState.playing:
            return IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: const Icon(Icons.pause),
              iconSize: iconSize,
              onPressed: playerManager.pause,
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
