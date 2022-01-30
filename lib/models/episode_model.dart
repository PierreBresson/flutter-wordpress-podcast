import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:html_unescape/html_unescape.dart';

class Episode {
  final int id;
  final String title;
  final String date;
  final String audioFileUrl;
  final String imageUrl;
  final String articleUrl;

  Episode({
    required this.id,
    required this.audioFileUrl,
    required this.articleUrl,
    required this.date,
    required this.title,
    required this.imageUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final app = dotenv.env['APP'];
    final unescape = HtmlUnescape();

    try {
      if (APP.thinkerview.name == app) {
        return Episode(
          id: json['id'] as int,
          title: unescape.convert(json['title']['rendered'] as String),
          date: json['date'] as String,
          audioFileUrl: json['meta']['audio_file'] as String,
          articleUrl: json['link'] as String,
          imageUrl: json['episode_featured_image'] as String,
        );
      } else if (APP.causecommune.name == app) {
        return Episode(
          id: json['id'] as int,
          title: unescape.convert(json['title']['rendered'] as String),
          date: json['date'] as String,
          audioFileUrl: json['meta']['audio_file'] as String,
          articleUrl: json['link'] as String,
          imageUrl: json['episode_player_image'] as String,
        );
      } else {
        throw "Incorrect app env variable";
      }
    } catch (e) {
      return Episode(
        id: 0,
        date: "",
        title: "",
        audioFileUrl: "",
        articleUrl: "",
        imageUrl: "",
      );
    }
  }

  @override
  String toString() {
    return 'Episode{id: $id, date: $date, audioFileUrl: $audioFileUrl, imageUrl: $imageUrl, title: $title, articleUrl $articleUrl}';
  }
}

class EpisodePlayable extends Episode {
  int positionInSeconds;

  @override
  EpisodePlayable({
    required this.positionInSeconds,
    required int id,
    required String audioFileUrl,
    required String date,
    required String title,
    required String imageUrl,
    required String articleUrl,
  }) : super(
          id: id,
          date: date,
          audioFileUrl: audioFileUrl,
          articleUrl: articleUrl,
          imageUrl: imageUrl,
          title: title,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'audioFileUrl': audioFileUrl,
      'articleUrl': articleUrl,
      'imageUrl': imageUrl,
      'title': title,
      'positionInSeconds': positionInSeconds,
    };
  }

  @override
  String toString() {
    return 'EpisodePlayable{id: $id, date: $date, audioFileUrl: $audioFileUrl, imageUrl: $imageUrl, title: $title, positionInSeconds: $positionInSeconds, articleUrl: $articleUrl}';
  }
}
