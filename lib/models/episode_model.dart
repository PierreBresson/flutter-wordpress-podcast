import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:html_unescape/html_unescape.dart';

// class Episode {
//   int? id;
//   String? title;
//   String? audioFileUrl;
//   String? date;
//   String? imageUrl;

//   // Meta? meta;
//   // EpisodeFeaturedImage? episodeFeaturedImage;
//   // EpisodePlayerImage? episodePlayerImage;

//   Episode({this.id, this.title, this.imageUrl});

//   Episode.fromJson(dynamic json) {
//     id = json['id'] as int;
//     title =
//         json['title'] != null ? Title.fromJson(json['title']).rendered : null;
//     audioFileUrl = json['meta'] != null
//         ? AudioFile.fromJson(json['meta']).audioFile
//         : null;
//     date = json['date'] as String;

//     imageUrl = "";

//     final app = dotenv.env['APP'];

//     if (APP.thinkerview.name == app) {
//       imageUrl = json["episode_featured_image"] as String;
//     }
//     if (APP.causeCommune.name == app) {
//       imageUrl = json["episode_player_image"] as String;
//     }
//   }
// }

// class Title {
//   String? rendered;

//   Title({this.rendered});

//   Title.fromJson(dynamic json) {
//     rendered = json['rendered'] as String;
//   }
// }

// class AudioFile {
//   String? audioFile;

//   AudioFile({this.audioFile});

//   AudioFile.fromJson(dynamic json) {
//     audioFile = json["audio_file"] as String;
//   }
// }

class Episode {
  final int id;
  final String title;
  final String date;
  final String audioFileUrl;
  final String imageUrl;

  Episode({
    required this.id,
    required this.audioFileUrl,
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
        throw "Incorrect app env variable";
      }
    } catch (e) {
      return Episode(
        id: 0,
        audioFileUrl: "",
        date: "",
        title: "",
        imageUrl: "",
      );
    }
  }
}
