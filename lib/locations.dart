import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:fwp/screens/screens.dart';

const homePath = 'home';
const searchPath = 'search';
const episodesCategoryPath = 'episodes_category';
const episodesCategoryarticlePath = 'episodes_category_article';
const articlePath = 'article';
const captainFactPath = 'captain_fact';

const homeEpisodesCategoryPath = '/$homePath/$episodesCategoryPath';
const homeEpisodesCategoryArticlePath =
    '/$homePath/$episodesCategoryPath/$episodesCategoryarticlePath';
const homeArticlePath = '/$homePath/$articlePath';
const homeCaptainFactPath = '/$homePath/$captainFactPath';

const searchArticlePath = '/$searchPath/$articlePath';
const searchCaptainFactPath = '/$searchPath/$captainFactPath';

class HomeLocation extends BeamLocation<BeamState> {
  HomeLocation(super.routeInformation);

  @override
  List<String> get pathPatterns =>
      [homeEpisodesCategoryPath, homeArticlePath, homeCaptainFactPath];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<String> pathPatternSegments = state.pathPatternSegments;
    final beamPages = [
      BeamPage(
        key: const ValueKey(homePath),
        title: 'Home',
        type: BeamPageType.noTransition,
        child: HomeScreen(),
      )
    ];

    if (pathPatternSegments.contains(episodesCategoryPath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(homeEpisodesCategoryPath),
          title: 'EpisodesCategory',
          child: EpisodesOfCategory(),
        ),
      );
    }

    if (pathPatternSegments.contains(articlePath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(homeArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      );
    }

    if (pathPatternSegments.contains(episodesCategoryarticlePath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(homeEpisodesCategoryArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      );
    }

    if (pathPatternSegments.contains(captainFactPath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(
            homeCaptainFactPath,
          ),
          title: 'Captain Fact',
          child: EpisodeDetailsCaptainFact(),
        ),
      );
    }

    return beamPages;
  }
}

class PlayerLocation extends BeamLocation<BeamState> {
  PlayerLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('player'),
          title: 'Player',
          type: BeamPageType.noTransition,
          child: PlayerScreen(),
        ),
      ];
}

class SearchLocation extends BeamLocation<BeamState> {
  SearchLocation(super.routeInformation);

  @override
  List<String> get pathPatterns => [searchArticlePath, searchCaptainFactPath];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<String> pathPatternSegments = state.pathPatternSegments;
    final beamPages = [
      const BeamPage(
        key: ValueKey('search'),
        title: 'Search',
        type: BeamPageType.noTransition,
        child: SearchScreen(),
      )
    ];

    if (pathPatternSegments.contains(articlePath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(searchArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      );
    }

    if (pathPatternSegments.contains(captainFactPath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(
            searchCaptainFactPath,
          ),
          title: 'Captain Fact',
          child: EpisodeDetailsCaptainFact(),
        ),
      );
    }

    return beamPages;
  }
}

class BooksLocation extends BeamLocation<BeamState> {
  BooksLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('books'),
          title: 'Books',
          type: BeamPageType.noTransition,
          child: BooksScreen(),
        ),
      ];
}

class AboutLocation extends BeamLocation<BeamState> {
  AboutLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('about'),
          title: 'About',
          type: BeamPageType.noTransition,
          child: AboutScreen(),
        ),
      ];
}
