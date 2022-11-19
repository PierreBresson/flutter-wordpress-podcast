import 'package:flutter/material.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class EpisodesOfCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          "Livres",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Livres",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: const Text("category"),
    );
  }
}
