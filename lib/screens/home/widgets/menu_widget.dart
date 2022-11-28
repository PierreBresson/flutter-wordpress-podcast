import 'package:flutter/material.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/styles/styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuSheet extends HookConsumerWidget {
  const MenuSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = isAppInDarkMode(context);
    void updateCurrentScreen(Screens screen) {
      ref.read(homeMenuProvider.notifier).update((state) => screen);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 5,
              width: 42,
              color: isDarkMode ? Colors.grey : Colors.black38,
            ),
          ),
        ),
        const SizedBox(height: 10),
        MenuItem(
          name: Screens.latestEpisodes.translate(),
          onTap: () {
            updateCurrentScreen(Screens.latestEpisodes);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        MenuItem(
          name: Screens.categories.translate(),
          onTap: () {
            updateCurrentScreen(Screens.categories);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        MenuItem(
          name: Screens.offline.translate(),
          onTap: () {
            updateCurrentScreen(Screens.offline);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final Screens currentScreen;
  final VoidCallback onPressed;

  const MenuButton({
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

class MenuItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const MenuItem({
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
