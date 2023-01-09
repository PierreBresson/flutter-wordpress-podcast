import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(homeMenuProvider);
    Future<void> onPressedMenu(BuildContext context) {
      return showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext context) => const HomeMenuSheet(),
      );
    }

    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          LocaleKeys.home_screen_title.tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeMenuButton(
              currentScreen: currentScreen,
              onPressed: () => onPressedMenu(context),
            ),
          ],
        ),
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(Icons.navigation),
              onPressed: () async {
//
              },
            )
          : null,
      body: Column(
        children: [
          if (currentScreen == HomeScreens.latestEpisodes) ...[
            Expanded(
              child: LatestEpisodes(),
            ),
          ] else if (currentScreen == HomeScreens.categories) ...[
            Expanded(
              child: Categories(),
            ),
          ] else if (currentScreen == HomeScreens.offline) ...[
            Expanded(
              child: OfflineEpisodes(),
            ),
          ]
        ],
      ),
    );
  }
}
