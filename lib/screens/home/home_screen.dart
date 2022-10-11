import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  // Future<void> _fetchPage(int pageKey) async {
  //   try {
  //     List<Episode> episodes = [];

  //     final app = dotenv.env['APP'];

  //     if (app == APP.thinkerview.name) {
  //       episodes = await httpRepository.getEpisodesFromCategory(
  //         page: pageKey,
  //         categories: 9,
  //       );
  //     } else if (app == APP.causecommune.name) {
  //       episodes = await httpRepository.getEpisodes(
  //         page: pageKey,
  //       );
  //     }

  //     final List<Episode> newItems = episodes;
  //     final nextPageKey = pageKey + 1;
  //     _pagingController.appendPage(newItems, nextPageKey);
  //   } catch (error) {
  //     _pagingController.error = error;
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDarkMode = isAppInDarkMode(context);
    final pairs = ref.watch(episodesProvider);

    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          "Derniers épisodes",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Derniers épisodes",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Text("er"),
    );
  }
}


// PagedListView.separated(
//         pagingController: _pagingController,
//         builderDelegate: PagedChildBuilderDelegate<Episode>(
//           animateTransitions: true,
//           firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
//             onTryAgain: _pagingController.refresh,
//           ),
//           itemBuilder: (context, episode, index) => EpisodeCard(
//             imageUrl: episode.imageUrl,
//             title: episode.title,
//             audioFileUrl: episode.audioFileUrl,
//             onPressed: () {
//               showModalBottomSheet<void>(
//                 backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
//                 isScrollControlled: true,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 context: context,
//                 builder: (BuildContext context) =>
//                     EpisodeOptions(episode: episode),
//               );
//             },
//           ),
//         ),
//         separatorBuilder: (context, index) => const SizedBox(
//           height: 2,
//         ),