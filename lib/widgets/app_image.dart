import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';

class AppImage extends StatelessWidget {
  const AppImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = dotenv.env['APP'];
    String imageUri = "";

    if (app == APP.thinkerview.name) {
      imageUri = 'assets/images/thinkerview.png';
    } else if (app == APP.causecommune.name) {
      imageUri = 'assets/images/cause-commune.png';
    }
    return Image(
      image: AssetImage(
        imageUri,
      ),
    );
  }
}
