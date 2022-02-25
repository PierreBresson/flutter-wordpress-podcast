import 'package:flutter/material.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/app_image.dart';

class AudioMetaData extends StatelessWidget {
  const AudioMetaData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();
    final screenWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<MetaDataAudioState>(
      valueListenable: playerManager.metaDataAudioNotifier,
      builder: (_, value, __) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderImage(value.artUri, screenWidth > 350 ? 300 : 200),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  value.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget renderImage(Uri audioUri, double imageMaxWidth) {
    if (audioUri.toString().isEmpty) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: imageMaxWidth),
        child: const AppImage(),
      );
    }

    return Flex(
      direction: Axis.vertical,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: imageMaxWidth),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.35),
                  spreadRadius: 8,
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Image(
              fit: BoxFit.contain,
              image: NetworkImage(
                audioUri.toString(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
