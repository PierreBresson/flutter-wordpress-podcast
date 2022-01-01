import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:http/http.dart';

const thinkerviewUrl = "thinkerview.com";
const causeCommuneUrl = "cause-commune.fm";

class HttpRepository {
  String getBaseUrl() {
    final app = dotenv.env['APP'];
    var baseUrl = "";

    if (app == APP.thinkerview.name) {
      baseUrl = thinkerviewUrl;
    } else if (app == APP.causeCommune.name) {
      baseUrl = causeCommuneUrl;
    }

    return baseUrl;
  }

  Future<List<Episode>> getEpisodesFromCategory({
    int page = 1,
    int? categories,
  }) async {
    final baseUrl = getBaseUrl();
    final String url = "https://$baseUrl/wp-json/wp/v2/posts?";

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
              Episode.fromJson(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return episodes;
    } else {
      throw "Impossible de recuperer les episodes";
    }
  }

  Future<List<Episode>> getEpisodes({int page = 1}) async {
    final baseUrl = getBaseUrl();

    final String url = "https://$baseUrl/wp-json/wp/v2/podcast?";
    final String pageURL = "page=$page";
    final Response response = await get(Uri.parse(url + pageURL));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodes = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJson(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return episodes;
    } else {
      throw "Impossible de recuperer les episodes";
    }
  }

  Future<List<Episode>> searchEpisode(String searchText) async {
    final baseUrl = getBaseUrl();

    final String url = "https://$baseUrl/wp-json/wp/v2/search?search=";
    final Response response = await get(Uri.parse(url + searchText));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodes = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJson(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return episodes;
    } else {
      throw "La recherche a échoué";
    }
  }
}
