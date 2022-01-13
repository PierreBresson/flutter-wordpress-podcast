import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/notifiers/notifiers.dart';
import 'package:fwp/repositories/repositories.dart';

class AudioMetaData extends StatelessWidget {
  const AudioMetaData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();

    return ValueListenableBuilder<MetaDataAudioState>(
      valueListenable: playerManager.metaDataAudioNotifier,
      builder: (_, value, __) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: renderImage(value.artUri),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  value.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Image renderImage(Uri audioUri) {
    final app = dotenv.env['APP'];
    String imageUri = "";

    if (app == APP.thinkerview.name) {
      imageUri = 'assets/images/thinkerview.png';
    } else if (app == APP.causecommune.name) {
      imageUri = 'assets/images/cause-commune.png';
    }

    if (audioUri.toString().isEmpty) {
      return Image(
        image: AssetImage(
          imageUri,
        ),
      );
    }

    return Image(image: NetworkImage(audioUri.toString()));
  }
}
