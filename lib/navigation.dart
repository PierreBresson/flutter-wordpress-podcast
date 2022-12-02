import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/locations.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _homePath = "/$homePath";
const _playerPath = "/player";
const _searchPath = "/search";
const _booksPath = "/books";
const _aboutPath = "/about";

final _isThinkerviewApp = dotenv.env['APP'] == APP.thinkerview.name;

class ScaffoldWithBottomNavBar extends ConsumerStatefulWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
  });

  @override
  ConsumerState<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState
    extends ConsumerState<ScaffoldWithBottomNavBar> {
  final _routerDelegates = [
    BeamerDelegate(
      initialPath: _homePath,
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains(_homePath)) {
          return HomeLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: _playerPath,
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains(_playerPath)) {
          return PlayerLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: _searchPath,
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains(_searchPath)) {
          return SearchLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    if (_isThinkerviewApp)
      BeamerDelegate(
        initialPath: _booksPath,
        locationBuilder: (routeInformation, _) {
          if (routeInformation.location!.contains(_booksPath)) {
            return BooksLocation(routeInformation);
          }
          return NotFound(path: routeInformation.location!);
        },
      ),
    BeamerDelegate(
      initialPath: _aboutPath,
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains(_aboutPath)) {
          return AboutLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: ref.watch(tabIndexProvider).index,
        children: [
          Beamer(
            routerDelegate: _routerDelegates[0],
          ),
          Beamer(
            routerDelegate: _routerDelegates[1],
          ),
          Beamer(
            routerDelegate: _routerDelegates[2],
          ),
          Beamer(
            routerDelegate: _routerDelegates[3],
          ),
          if (_isThinkerviewApp)
            Beamer(
              routerDelegate: _routerDelegates[4],
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: ref.watch(tabIndexProvider).index,
        items: [
          BottomNavigationBarItem(
            label: LocaleKeys.bottom_bar_navigation_home.tr(),
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.bottom_bar_navigation_player.tr(),
            icon: const Icon(Icons.music_note),
          ),
          BottomNavigationBarItem(
            label: LocaleKeys.bottom_bar_navigation_search.tr(),
            icon: const Icon(Icons.search),
          ),
          if (_isThinkerviewApp)
            BottomNavigationBarItem(
              label: LocaleKeys.bottom_bar_navigation_books.tr(),
              icon: const Icon(Icons.book),
            ),
          BottomNavigationBarItem(
            label: LocaleKeys.bottom_bar_navigation_about.tr(),
            icon: const Icon(Icons.info),
          ),
        ],
        onTap: (index) {
          final tabIndex = ref.watch(tabIndexProvider);
          ref.read(tabIndexProvider.notifier).updateTabIndex(index);

          if (index != tabIndex.index) {
            _routerDelegates[tabIndex.index].update(rebuild: false);
          }
        },
      ),
    );
  }
}
