import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:http/http.dart';

const nbOfEpisodesPerPage = 10;
const nbOfEpisodesCategoriesPerPage = 10;
const _apiPath = "wp-json/wp/v2";
const _thinkerviewUrl = "thinkerview.com";
const _causeCommuneUrl = "cause-commune.fm";
const _amountPerPagePath = "per_page=";
const _pagePath = "page=";
const _categoriesPathThinkerview = "categories";
const _categoriesPathCauseCommune = "series";

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
          "$url$_pagePath$pageIndex&$_amountPerPagePath$nbOfEpisodesPerPage",
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
          print("TODO getEpisodes request error $error");
        }
      }

      return Episodes(
        items: episodesItems,
        total: total,
      );
    } else {
      if (kDebugMode) {
        print("TODO getEpisodes invalid response");
      }
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
    String categoriesPath = "";

    if (app == APP.thinkerview.name) {
      categoriesPath = _categoriesPathThinkerview;
    } else if (app == APP.causecommune.name) {
      categoriesPath = _categoriesPathCauseCommune;
    }

    final String categoryQuery =
        categories.toString().isEmpty ? "&$categoriesPath=$categories" : "";
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
    late Response response;

    try {
      response = await get(Uri.parse(url + searchText));
    } catch (error) {
      if (kDebugMode) {
        print("TODO search request failed $error");
      }
      throw "La recherche a échoué";
    }

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      // ignore: avoid_dynamic_calls
      final List<int> ids = body.map((post) => post['id'] as int).toList();

      return ids;
    } else {
      if (kDebugMode) {
        print("TODO error incorrect search");
      }
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

  Future<EpisodesCategories> getEpisodesCategories({int pageIndex = 1}) async {
    final baseUrl = _getBaseUrl();
    String url = "https://$baseUrl/$_apiPath/";

    if (app == APP.thinkerview.name) {
      url = url + _categoriesPathThinkerview;
    } else if (app == APP.causecommune.name) {
      url = url + _categoriesPathCauseCommune;
    }

    late Response response;

    try {
      response = await get(
        Uri.parse(
          "$url?$_pagePath$pageIndex&$_amountPerPagePath$nbOfEpisodesCategoriesPerPage",
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        print("TODO getEpisodesCategories request failed $error");
      }
      throw Exception();
    }

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;

      final List<EpisodesCategory> episodesItems = body.map(
        (dynamic item) {
          final EpisodesCategory episodesCategory =
              EpisodesCategory.fromJson(item as Map<String, dynamic>);
          return episodesCategory;
        },
      ).toList();

      int total = 100;

      try {
        total = int.parse(response.headers['x-wp-total']!);
      } catch (error) {
        if (kDebugMode) {
          print("TODO error parse x-wp-total $error");
        }
      }

      return EpisodesCategories(
        items: episodesItems,
        total: total,
      );
    } else {
      if (kDebugMode) {
        print("TODO getEpisodesCategories incorrect response");
      }
      throw Exception();
    }
  }
}
