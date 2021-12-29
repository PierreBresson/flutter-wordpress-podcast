import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
      final episodes =
          await httpRepository.getEpisodes(page: pageKey, categories: 9);

      final List<Episode> newItems = episodes;

      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems, nextPageKey);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
          height: 16,
        ),
      ),
    );
  }
}
