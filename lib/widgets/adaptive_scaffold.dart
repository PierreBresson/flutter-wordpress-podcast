import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final TitleBar? titleBar;
  const AdaptiveScaffold({
    Key? key,
    required this.appBar,
    required this.body,
    this.titleBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return MacosScaffold(
        // backgroundColor: Theme.of(context).backgroundColor,
        titleBar: titleBar,
        children: [
          ContentArea(
            builder: (context, scrollController) => body,
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: body,
    );
  }
}
