import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:fwp/screens/screens.dart';

const _homePath = 'home';
const _categoryPath = 'category';
const _articlePath = 'article';
const _captainFactPath = 'captain_fact';

const homeCategoryPath = '/$_homePath/$_categoryPath';
const homeArticlePath = '/$_homePath/$_articlePath';
const homeCaptainFactPath = '/$_homePath/$_captainFactPath';

class HomeLocation extends BeamLocation<BeamState> {
  final ScrollController homeController;
  HomeLocation(super.routeInformation, this.homeController);

  @override
  List<String> get pathPatterns =>
      [homeCategoryPath, homeArticlePath, homeCaptainFactPath];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<String> pathPatternSegments = state.pathPatternSegments;

    return [
      BeamPage(
        key: const ValueKey(_homePath),
        title: 'Home',
        type: BeamPageType.noTransition,
        child: HomeScreen(scrollController: homeController),
      ),
      if (pathPatternSegments.contains(_categoryPath))
        BeamPage(
          key: const ValueKey(homeCategoryPath),
          title: 'Category',
          child: EpisodesOfCategory(
            scrollController: homeController,
          ),
        ),
      if (pathPatternSegments.contains(_articlePath))
        const BeamPage(
          key: ValueKey(homeArticlePath),
          title: 'Article',
          child: EpisodeDetails(),
        ),
      if (pathPatternSegments.contains(_captainFactPath))
        BeamPage(
          key: const ValueKey(
            homeCaptainFactPath,
          ),
          title: 'Captain Fact',
          child: EpisodeDetailsCaptainFact(),
        )
    ];
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
