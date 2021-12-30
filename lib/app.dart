import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/blocs/blocs.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/screens/screens.dart';
import 'package:fwp/styles/themes.dart';

class FwpApp extends StatefulWidget {
  const FwpApp({
    Key? key,
  }) : super(key: key);

  @override
  State<FwpApp> createState() => _FwpAppState();
}

class _FwpAppState extends State<FwpApp> {
  final screensTitle = ["Accueil", "Lecteur", "Livres", "A propos"];
  final screens = const [
    HomeScreen(),
    PlayerScreen(),
    BooksScreen(),
    AboutScreen()
  ];

  @override
  void initState() {
    super.initState();
    getIt<PlayerManager>().init();
  }

  @override
  void dispose() {
    getIt<PlayerManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ligthThemeData,
      darkTheme: darkThemeData,
      home: BlocBuilder<BottomBarNavigationCubit, int>(
        builder: (_, index) => Scaffold(
          body: IndexedStack(
            index: index,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.house),
                label: screensTitle[0],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.music_note),
                label: screensTitle[1],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: screensTitle[2],
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.info),
                label: screensTitle[3],
              )
            ],
            currentIndex: index,
            onTap: (index) =>
                context.read<BottomBarNavigationCubit>().update(index),
          ),
        ),
      ),
    );
  }
}
