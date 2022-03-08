// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/foundation.dart';
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
  final String? youtubeUrl;
  final String description;

  Episode({
    required this.id,
    required this.audioFileUrl,
    required this.articleUrl,
    required this.date,
    required this.title,
    required this.imageUrl,
    required this.description,
    this.youtubeUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    final app = dotenv.env['APP'];
    final unescape = HtmlUnescape();

    try {
      final int id = json['id'] as int;
      final String title =
          unescape.convert(json['title']['rendered'] as String);
      final String date = json['date'] as String;
      final String audioFileUrl = json['meta']['audio_file'] as String;
      final String articleUrl = json['link'] as String;
      final String description = json["content"]["rendered"] as String;
      String imageUrl = "";
      String? youtubeUrl;

      if (APP.thinkerview.name == app) {
        imageUrl = json['episode_featured_image'] as String;
        /* in case acf plugin isn't working */
        try {
          final rendered = json['content']['rendered'] as String;
          final regexp = RegExp(
            r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube-nocookie\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?',
          );
          final match = regexp.firstMatch(rendered);
          final matchedText = match?.group(0);
          if (matchedText != null) {
            final id = matchedText.replaceAll(
              "https://www.youtube-nocookie.com/embed/",
              "",
            );
            youtubeUrl =
                "https://www.youtube.com/watch?v=${id.replaceAll('"', "")}";
          }
        } catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      } else if (APP.causecommune.name == app) {
        imageUrl = json['episode_player_image'] as String;
      }

      return Episode(
        id: id,
        title: title,
        date: date,
        audioFileUrl: audioFileUrl,
        articleUrl: articleUrl,
        imageUrl: imageUrl,
        youtubeUrl: youtubeUrl,
        description: description,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Episode(
        id: 0,
        date: "",
        title: "",
        audioFileUrl: "",
        articleUrl: "",
        imageUrl: "",
        description: "",
      );
    }
  }

  @override
  String toString() {
    return 'Episode{id: $id, date: $date, audioFileUrl: $audioFileUrl, imageUrl: $imageUrl, title: $title, articleUrl $articleUrl, description $description}';
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
    required String description,
  }) : super(
          id: id,
          date: date,
          audioFileUrl: audioFileUrl,
          articleUrl: articleUrl,
          imageUrl: imageUrl,
          title: title,
          description: description,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'audioFileUrl': audioFileUrl,
      'articleUrl': articleUrl,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'positionInSeconds': positionInSeconds,
    };
  }

  @override
  String toString() {
    return 'EpisodePlayable{id: $id, date: $date, audioFileUrl: $audioFileUrl, imageUrl: $imageUrl, title: $title, positionInSeconds: $positionInSeconds, articleUrl: $articleUrl, description $description}';
  }
}
