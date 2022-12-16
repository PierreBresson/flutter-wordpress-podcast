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
  int positionInSeconds;
  String? imagePath;
  String? audioFilePath;
  String? imageDownloadTaskId;
  String? audioFileDownloadTaskId;

  @override
  Episode({
    required this.id,
    required this.audioFileUrl,
    required this.articleUrl,
    required this.date,
    required this.title,
    required this.imageUrl,
    required this.description,
    this.youtubeUrl,
    this.positionInSeconds = 0,
    this.imageDownloadTaskId,
    this.imagePath,
    this.audioFileDownloadTaskId,
    this.audioFilePath,
  }) : super();

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
      'imageDownloadTaskId': imageDownloadTaskId,
      'audioFileDownloadTaskId': audioFileDownloadTaskId,
      'imagePath': imagePath,
      'audioFilePath': audioFilePath,
    };
  }

  @override
  String toString() {
    return 'Episode{id: $id, date: $date, audioFileUrl: $audioFileUrl, imageUrl: $imageUrl, title: $title, positionInSeconds: $positionInSeconds, articleUrl: $articleUrl, description $description, imageDownloadTaskId: $imageDownloadTaskId, audioFileDownloadTaskId: $audioFileDownloadTaskId, imagePath: $imagePath, audioFilePath: $audioFilePath }';
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    final app = dotenv.env['APP'];
    final unescape = HtmlUnescape();

    try {
      final int id = json['id'] as int;
      final String title =
          unescape.convert(json['title']['rendered'] as String);
      final String date = json['date'] as String;
      final String audioFileUrl =
          Uri.encodeFull(json['meta']['audio_file'] as String);
      final String articleUrl = json['link'] as String;
      final String description = json["content"]["rendered"] as String;
      String imageUrl = "";
      String? youtubeUrl;

      if (APP.thinkerview.name == app) {
        imageUrl = Uri.encodeFull(json['episode_featured_image'] as String);
        /* in case acf plugin isn't working */
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
      } else if (APP.causecommune.name == app) {
        imageUrl = Uri.encodeFull(json['episode_player_image'] as String);
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
        print("TODO Episode.fromJson error: $error");
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
}

class Episodes {
  final List<Episode> items;
  final int total;

  Episodes({
    required this.items,
    required this.total,
  });
}
