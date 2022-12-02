import 'package:flutter/material.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final tasks = await FlutterDownloader.loadTasks();
          print("tasks $tasks");

          if (tasks != null) {
            for (final task in tasks) {
              print(task.filename);
              print(task.progress);
              print(task.savedDir);
              print(task.status);
              print(task.taskId);
            }
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (currentScreen == Screens.latestEpisodes) ...[
            Expanded(
              child: LatestEpisodes(),
            ),
          ] else if (currentScreen == Screens.categories) ...[
            Expanded(
              child: Categories(),
            ),
          ] else if (currentScreen == Screens.offline) ...[
            const Expanded(
              child: OfflineEpisodes(),
            ),
          ]
        ],
      ),
    );
  }
}
