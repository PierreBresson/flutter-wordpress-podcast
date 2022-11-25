import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class HomeScreen extends HookConsumerWidget {
  final ScrollController scrollController;
  const HomeScreen({required this.scrollController});

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
        builder: (BuildContext context) => const MenuSheet(),
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
            MenuButton(
              currentScreen: currentScreen,
              onPressed: () => onPressedMenu(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (currentScreen == Screens.latestEpisodes) ...[
            Expanded(
              child: LatestEpisodes(
                scrollController: scrollController,
              ),
            ),
          ] else if (currentScreen == Screens.categories) ...[
            Expanded(
              child: Categories(
                scrollController: scrollController,
              ),
            ),
          ] else if (currentScreen == Screens.offline) ...[
            const Text("nothing here yet"),
          ]
        ],
      ),
    );
  }
}
