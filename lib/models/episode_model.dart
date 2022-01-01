import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:html_unescape/html_unescape.dart';

class Episode {
  final int id;
  final String title;
  final String date;
  final String audioFileUrl;
  final String imageUrl;

  Episode({
    required this.audioFileUrl,
    required this.date,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    print(json);
    final app = dotenv.env['APP'];
    final unescape = HtmlUnescape();

    if (APP.thinkerview.name == app) {
      return Episode(
        id: json['id'] as int,
        title: json['title']['rendered'] as String,
        date: json['date'] as String,
        audioFileUrl: json['meta']['audio_file'] as String,
        imageUrl: json['episode_featured_image'] as String,
      );
    } else if (APP.causeCommune.name == app) {
      return Episode(
        id: json['id'] as int,
        title: unescape.convert(json['title']['rendered'] as String),
        date: json['date'] as String,
        audioFileUrl: json['meta']['audio_file'] as String,
        imageUrl: json['episode_player_image'] as String,
      );
    } else {
      return Episode(
        audioFileUrl: "",
        date: "",
        id: 1,
        title: "",
        imageUrl: "",
      );
    }
  }
}
