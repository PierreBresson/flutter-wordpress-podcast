import 'package:flutter/material.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/widgets/bottom_sheet_header_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeMenuSheet extends HookConsumerWidget {
  const HomeMenuSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void updateCurrentScreen(HomeScreens screen) {
      ref.read(homeMenuProvider.notifier).update((state) => screen);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BottomSheetHeader(),
        HomeMenuItem(
          name: HomeScreens.latestEpisodes.translate(),
          onTap: () {
            updateCurrentScreen(HomeScreens.latestEpisodes);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        HomeMenuItem(
          name: HomeScreens.categories.translate(),
          onTap: () {
            updateCurrentScreen(HomeScreens.categories);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        HomeMenuItem(
          name: HomeScreens.offline.translate(),
          onTap: () {
            updateCurrentScreen(HomeScreens.offline);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  final HomeScreens currentScreen;
  final VoidCallback onPressed;

  const HomeMenuButton({
    super.key,
    required this.currentScreen,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black26,
        splashFactory: NoSplash.splashFactory,
        shape: const StadiumBorder(),
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Text(
              currentScreen.translate(),
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.expand_more_rounded,
              size: 24,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMenuItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const HomeMenuItem({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}
