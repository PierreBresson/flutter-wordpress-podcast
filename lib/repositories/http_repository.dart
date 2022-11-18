import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:http/http.dart';

const nbOfEpisodesPerPage = 10;
const _apiPath = "wp-json/wp/v2";
const _thinkerviewUrl = "thinkerview.com";
const _causeCommuneUrl = "cause-commune.fm";
const _episodesPerPagePath = "per_page=";
const _pagePath = "page=";
const _categoriesPath = "categories=";

List<Episode> _removeEmptyEpisodes(List<Episode> episodes) {
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
  final app = dotenv.env['APP'];

  String _getBaseUrl() {
    var baseUrl = "";

    if (app == APP.thinkerview.name) {
      baseUrl = _thinkerviewUrl;
    } else if (app == APP.causecommune.name) {
      baseUrl = _causeCommuneUrl;
    }

    return baseUrl;
  }

  String _getEndingOptionPath() {
    var endingOptionPath = "";

    if (app == APP.thinkerview.name) {
      endingOptionPath = "posts?";
    } else if (app == APP.causecommune.name) {
      endingOptionPath = "podcast?";
    }

    return endingOptionPath;
  }

  Future<Episodes> getEpisodes({int pageIndex = 1}) async {
    final baseUrl = _getBaseUrl();
    final endingOptionPath = _getEndingOptionPath();

    final String url = "https://$baseUrl/$_apiPath/$endingOptionPath";
    late Response response;

    try {
      response = await get(
        Uri.parse(
          "$url$_pagePath$pageIndex&$_episodesPerPagePath$nbOfEpisodesPerPage",
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print("TODO error $error");
      }
      throw "Impossible de recuperer les episodes";
    }

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<Episode> episodesItems = body.map(
        (dynamic item) {
          final Episode newEpisode =
              Episode.fromJson(item as Map<String, dynamic>);
          return newEpisode;
        },
      ).toList();

      int total = 100;

      try {
        total = int.parse(response.headers['x-wp-total']!);
      } catch (error) {
        if (kDebugMode) {
          print("TODO error $error");
        }
      }

      return Episodes(
        items: episodesItems,
        total: total,
      );
    } else {
      throw "Impossible de recuperer les episodes";
    }
  }

  Future<List<Episode>> getEpisodesFromCategory({
    int pageIndex = 1,
    int? categories,
  }) async {
    final baseUrl = _getBaseUrl();
    final endingOptionPath = _getEndingOptionPath();
    final String url = "https://$baseUrl/$_apiPath/$endingOptionPath";

    final String categoryQuery =
        categories.toString().isEmpty ? "&$_categoriesPath$categories" : "";
    late Response response;

    try {
      response = await get(
        Uri.parse(url + _pagePath + pageIndex.toString() + categoryQuery),
      );
    } catch (error) {
      if (kDebugMode) {
        print("TODO error $error");
      }
      throw "Impossible de recuperer les episodes";
    }

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
    final baseUrl = _getBaseUrl();

    final String url = "https://$baseUrl/$_apiPath/search?search=";
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
    final baseUrl = _getBaseUrl();
    final endingOptionPath = _getEndingOptionPath();
    var query = "";

    if (ids.isNotEmpty) {
      ids.map((item) => query = "$query$item,").toList();
    }

    final String url = "https://$baseUrl/$_apiPath/${endingOptionPath}include=";
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

      return _removeEmptyEpisodes(episodes);
    } else {
      throw "La recherche a échoué";
    }
  }
}
