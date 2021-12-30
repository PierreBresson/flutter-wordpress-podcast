import 'dart:convert';
import 'package:fwp/models/models.dart';
import 'package:http/http.dart';

class HttpRepository {
  Future<List<Episode>> getEpisodesFromCategory(
      {int page = 1, int? categories}) async {
    const String url = "https://www.thinkerview.com/wp-json/wp/v2/posts?";
    final String pageURL = "page=$page";
    final String categoriesURL =
        categories.toString().isEmpty ? "&categories=$categories" : "";
    final Response response =
        await get(Uri.parse(url + pageURL + categoriesURL));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodes = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJsonThinkerview(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return episodes;
    } else {
      throw "Impossible de recuperer les episodes";
    }
  }

  Future<List<Episode>> getEpisodes({int page = 1}) async {
    const String url = "https://cause-commune.fm/wp-json/wp/v2/podcast?";
    final String pageURL = "page=$page";
    final Response response = await get(Uri.parse(url + pageURL));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodes = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJsonCauseCommune(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return episodes;
    } else {
      throw "Impossible de recuperer les episodes";
    }
  }
}
