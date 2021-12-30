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

  factory Episode.fromJsonThinkerview(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      date: json['date'] as String,
      audioFileUrl: json['meta']['audio_file'] as String,
      imageUrl: json['episode_featured_image'] as String,
    );
  }

  factory Episode.fromJsonCauseCommune(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    return Episode(
      id: json['id'] as int,
      title: unescape.convert(json['title']['rendered'] as String),
      date: json['date'] as String,
      audioFileUrl: json['meta']['audio_file'] as String,
      imageUrl: json['episode_player_image'] as String,
    );
  }
}
