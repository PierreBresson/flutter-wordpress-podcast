import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macos_ui/macos_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HttpRepository httpRepository = HttpRepository();
  final _pagingController = PagingController<int, Episode>(
    firstPageKey: 1,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Episode> episodes = [];

      final app = dotenv.env['APP'];

      if (app == APP.thinkerview.name) {
        episodes = await httpRepository.getEpisodesFromCategory(
          page: pageKey,
          categories: 9,
        );
      } else if (app == APP.causecommune.name) {
        episodes = await httpRepository.getEpisodes(
          page: pageKey,
        );
      }

      final List<Episode> newItems = episodes;
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return AdaptiveScaffold(
      titleBar: const TitleBar(title: Text("Derniers épisodes")),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Derniers épisodes",
          style: FWPTypography(context).h6(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Episode>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (_) => ErrorIndicator(
              error: _pagingController.error.toString(),
              onTryAgain: _pagingController.refresh,
            ),
            itemBuilder: (context, episode, index) => EpisodeCard(
              imageUrl: episode.imageUrl,
              title: episode.title,
              audioFileUrl: episode.audioFileUrl,
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: isDarkMode ? Colors.black : Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) =>
                      EpisodeOptions(episode: episode),
                );
              },
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 2,
          ),
        ),
      ),
    );
  }
}
