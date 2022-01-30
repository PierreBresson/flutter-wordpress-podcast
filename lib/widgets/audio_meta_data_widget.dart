import 'package:flutter/material.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';
import './app_image.dart';

class AudioMetaData extends StatelessWidget {
  const AudioMetaData({Key? key}) : super(key: key);

  double getImageWidth(double screenWidth) {
    var imageWidth = 180.0;

    if (screenWidth > 340.0) {
      imageWidth = 220.0;
    }
    if (screenWidth > 370) {
      imageWidth = 260.0;
    }
    if (screenWidth >= 390) {
      imageWidth = 300.0;
    }

    if (screenWidth > 500) {
      imageWidth = 400.0;
    }

    return imageWidth;
  }

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
              SizedBox(
                width: getImageWidth(screenWidth),
                child: renderImage(value.artUri),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  value.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget renderImage(Uri audioUri) {
    if (audioUri.toString().isEmpty) {
      return const AppImage();
    }

    return Image(image: NetworkImage(audioUri.toString()));
  }
}
