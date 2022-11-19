import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fwp/screens/home/widgets/widgets.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;
  const HomeScreen({required this.scrollController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = 0;

  Widget buildSegment({required String text, required bool isSelected}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          "Accueil",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Accueil",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CupertinoSlidingSegmentedControl<int>(
                thumbColor: Theme.of(context).colorScheme.primary,
                groupValue: groupValue,
                children: {
                  0: buildSegment(
                    text: "Derniers épisodes",
                    isSelected: groupValue == 0,
                  ),
                  1: buildSegment(
                    text: "Catégories",
                    isSelected: groupValue == 1,
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    groupValue = value!;
                  });
                },
              ),
            ),
          ),
          if (groupValue == 0) ...[
            Expanded(
              child: LatestEpisodes(
                scrollController: widget.scrollController,
              ),
            ),
          ] else ...[
            Expanded(
              child: Categories(
                scrollController: widget.scrollController,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
