import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

final httpRepository = Provider<HttpRepository>((ref) => HttpRepository(ref));

const apiPath = "wp-json/wp/v2";
const thinkerviewUrl = "thinkerview.com";
const causeCommuneUrl = "cause-commune.fm";

List<Episode> removeEmptyEpisodes(List<Episode> episodes) {
  return episodes
      .where(
        (element) =>
            element.audioFileUrl.isNotEmpty &&
            element.imageUrl.isNotEmpty &&
            element.title.isNotEmpty,
      )
      .toList();
}

class HttpRepository {
  final Ref read;
  HttpRepository(this.read);

  final app = dotenv.env['APP'];

  String getBaseUrl() {
    var baseUrl = "";

    if (app == APP.thinkerview.name) {
      baseUrl = thinkerviewUrl;
    } else if (app == APP.causecommune.name) {
      baseUrl = causeCommuneUrl;
    }

    return baseUrl;
  }

  String getEndingOptionPath() {
    var endingOptionPath = "";

    if (app == APP.thinkerview.name) {
      endingOptionPath = "posts?";
    } else if (app == APP.causecommune.name) {
      endingOptionPath = "podcast?";
    }

    return endingOptionPath;
  }

  Future<List<Episode>> getEpisodesFromCategory({
    int page = 1,
    int? categories,
  }) async {
    final baseUrl = getBaseUrl();
    final endingOptionPath = getEndingOptionPath();
    final String url = "https://$baseUrl/$apiPath/$endingOptionPath";

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
    final endingOptionPath = getEndingOptionPath();

    final String url = "https://$baseUrl/$apiPath/$endingOptionPath";
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

  Future<List<int>> search(String searchText) async {
    final baseUrl = getBaseUrl();

    final String url = "https://$baseUrl/$apiPath/search?search=";
    final Response response = await get(Uri.parse(url + searchText));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      // ignore: avoid_dynamic_calls
      final List<int> ids = body.map((post) => post['id'] as int).toList();

      return ids;
    } else {
      throw "La recherche a échoué";
    }
  }

  Future<List<Episode>> getEpisodesByIds(List<int> ids) async {
    final baseUrl = getBaseUrl();
    final endingOptionPath = getEndingOptionPath();
    var query = "";

    if (ids.isNotEmpty) {
      ids.map((item) => query = "$query$item,").toList();
    }

    final String url = "https://$baseUrl/$apiPath/${endingOptionPath}include=";
    final Response response = await get(Uri.parse(url + query));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodes = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJson(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      return removeEmptyEpisodes(episodes);
    } else {
      throw "La recherche a échoué";
    }
  }
}
