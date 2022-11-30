import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:fwp/screens/screens.dart';

const homePath = 'home';
const _episodesCategoryPath = 'episodes_category';
const _episodesCategoryarticlePath = 'episodes_category_article';
const _articlePath = 'article';
const _captainFactPath = 'captain_fact';

const homeEpisodesCategoryPath = '/$homePath/$_episodesCategoryPath';
const homeEpisodesCategoryArticlePath =
    '/$homePath/$_episodesCategoryPath/$_episodesCategoryarticlePath';
const homeArticlePath = '/$homePath/$_articlePath';
const homeCaptainFactPath = '/$homePath/$_captainFactPath';

class HomeLocation extends BeamLocation<BeamState> {
  final ScrollController homeController;
  HomeLocation(super.routeInformation, this.homeController);

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
        child: HomeScreen(scrollController: homeController),
      )
    ];

    if (pathPatternSegments.contains(_episodesCategoryPath)) {
      beamPages.add(
        BeamPage(
          key: const ValueKey(homeEpisodesCategoryPath),
          title: 'EpisodesCategory',
          child: EpisodesOfCategory(
            scrollController: homeController,
          ),
        ),
      );
    }

    if (pathPatternSegments.contains(_articlePath)) {
      beamPages.add(
        const BeamPage(
          key: ValueKey(homeArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      );
    }

    if (pathPatternSegments.contains(_episodesCategoryarticlePath)) {
      beamPages.add(
        const BeamPage(
          key: ValueKey(homeEpisodesCategoryArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      );
    }

    if (pathPatternSegments.contains(_captainFactPath)) {
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
          key: ValueKey('a'),
          title: 'Tab A',
          type: BeamPageType.noTransition,
          child: PlayerScreen(),
        ),
      ];
}

class SearchLocation extends BeamLocation<BeamState> {
  SearchLocation(super.routeInformation);
  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('search'),
          title: 'Search',
          type: BeamPageType.noTransition,
          child: SearchScreen(),
        ),
      ];
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
