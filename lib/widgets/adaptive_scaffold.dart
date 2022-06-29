import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final TitleBar? titleBar;
  final FloatingActionButton? floatingActionButton;
  const AdaptiveScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.titleBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return MacosScaffold(
        // titleBar: titleBar,
        children: [
          ContentArea(
            builder: (context, scrollController) => Scaffold(
              backgroundColor: MacosTheme.of(context).canvasColor,
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
