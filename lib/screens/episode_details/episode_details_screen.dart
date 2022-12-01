import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EpisodeDetails extends HookConsumerWidget {
  final scrollController = ScrollController();

  void scrollToTopOrGoBack(BuildContext context) {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels == 0) {
        Navigator.of(context).maybePop();
      } else {
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      }
    }
  }

  EpisodeDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(episodeSelectedProvider);
    final DateTime dateTime = DateTime.parse(episode.date);
    final String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);

    ref.listen(tabIndexProvider, (previous, next) {
      final previousTabIndex = previous as TabIndex?;
      final nextTabIndex = next as TabIndex?;

      if (previousTabIndex != null && nextTabIndex != null) {
        if (previousTabIndex.index == 0 && nextTabIndex.index == 0) {
          scrollToTopOrGoBack(context);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          LocaleKeys.episode_details_screen_title.tr(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  episode.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  dateformat,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 20),
              HtmlWidget(episode.description),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
