import 'package:flutter/material.dart';

class EpisodeOptionsListItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;
  const EpisodeOptionsListItem({
    super.key,
    required this.iconData,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Icon(
        iconData,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}
