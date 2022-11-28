import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/locations.dart';
import 'package:fwp/models/models.dart';

const _homePath = "/home";
const _playerPath = "/player";
const _searchPath = "/search";
const _booksPath = "/books";
const _aboutPath = "/about";

final _isThinkerviewApp = dotenv.env['APP'] == APP.thinkerview.name;
final ScrollController _homeController = ScrollController();

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
  });

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  final _routerDelegates = [
    BeamerDelegate(
      initialPath: _homePath,
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains(_homePath)) {
          return HomeLocation(routeInformation, _homeController);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String uriString = Beamer.of(context).configuration.location!;
    switch (uriString) {
      case _homePath:
        _currentIndex = 0;
        break;
      case _playerPath:
        _currentIndex = 1;
        break;
      case _searchPath:
        _currentIndex = 2;
        break;
      case _booksPath:
        _currentIndex = 3;
        break;
      case _aboutPath:
        _currentIndex = 4;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
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
        currentIndex: _currentIndex,
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
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            _routerDelegates[_currentIndex].update(rebuild: false);
          }
          if (index == 0) {
            if (_homeController.hasClients) {
              _homeController.jumpTo(_homeController.position.minScrollExtent);
            }
          }
        },
      ),
    );
  }
}
