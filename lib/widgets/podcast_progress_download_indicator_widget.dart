import 'package:flutter/material.dart';

class PodcastProgressDownloadIndicator extends StatelessWidget {
  final String name;
  final int progress;
  final VoidCallback onTap;

  const PodcastProgressDownloadIndicator({
    super.key,
    required this.name,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "$progress % - $name",
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: const Icon(
        Icons.cancel,
        size: 24,
      ),
      onTap: onTap,
    );
  }
}
