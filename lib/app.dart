import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/blocs/blocs.dart';
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
  final screensTitle = ["Accueil", "Lecteur", "A propos"];
  final screens = const [HomeScreen(), PlayerScreen(), AboutScreen()];

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
                icon: const Icon(Icons.info),
                label: screensTitle[2],
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
