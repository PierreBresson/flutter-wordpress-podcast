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
    return Episode(
      id: json['id'] as int,
      title: json['title']['rendered'] as String,
      date: json['date'] as String,
      audioFileUrl: json['meta']['audio_file'] as String,
      imageUrl: json['episode_featured_image'] as String,
    );
  }
}
