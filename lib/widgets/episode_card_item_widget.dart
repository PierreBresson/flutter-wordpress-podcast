import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

double imageHeigth = 200;
double circularProgressIndicatorSize = 20;
double verticalPadding = 18;
Radius circularRadius = const Radius.circular(14);
BorderRadius borderRadius = BorderRadius.only(
  topLeft: circularRadius,
  topRight: circularRadius,
);

class EpisodeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String audioFileUrl;
  final VoidCallback onPressed;
  final bool hasBeenPlayed;

  const EpisodeCard({
    Key? key,
    required this.hasBeenPlayed,
    required this.onPressed,
    required this.imageUrl,
    required this.title,
    required this.audioFileUrl,
  }) : super(key: key);

  BoxConstraints getConstraints(BuildContext context) {
    const maxWidth = 500.0;
    final maxWidgetWidth = MediaQuery.of(context).size.width - verticalPadding;

    return BoxConstraints(
      maxWidth: maxWidth,
      minWidth: maxWidgetWidth > maxWidth ? maxWidth : maxWidgetWidth,
    );
  }

  Color getBackgroundColor({bool isDarkMode = false}) {
    if (Platform.isMacOS) {
      return isDarkMode ? Colors.black : Colors.white;
    }
    return isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isAppInDarkMode(context);

    if (title == "" || imageUrl == "" || audioFileUrl == "") {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: verticalPadding, vertical: 12),
      child: Center(
        child: Container(
          constraints: getConstraints(context),
          decoration: BoxDecoration(
            color: getBackgroundColor(isDarkMode: isDarkMode),
            borderRadius: BorderRadius.all(circularRadius),
            boxShadow: isDarkMode
                ? null
                : [
                    const BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 16.0,
                    ),
                  ],
          ),
          child: InkWell(
            onTap: onPressed,
            child: Column(
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: imageHeigth,
                        constraints: getConstraints(context),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.white.withOpacity(0.2),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical:
                              imageHeigth / 2 - circularProgressIndicatorSize,
                        ),
                        child: SizedBox(
                          width: circularProgressIndicatorSize,
                          height: circularProgressIndicatorSize,
                          child: const CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                        height: imageHeigth,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 24,
                          ),
                          child: AppImage(),
                        ),
                      ),
                    ),
                    if (hasBeenPlayed) ...[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Icon(
                            Icons.check_circle,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ] else ...[
                      const SizedBox.shrink()
                    ],
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: 20,
                  ),
                  constraints: getConstraints(context),
                  child: Text(
                    title +
                        (hasBeenPlayed ? " - already played" : " - not played"),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final currentEpisode = Provider<AsyncValue<Episode>>((ref) {
  throw UnimplementedError();
});

class EpisodeCardItem extends HookConsumerWidget {
  void onPressed(BuildContext context, Episode episode) {
    final isDarkMode = isAppInDarkMode(context);

    showModalBottomSheet<void>(
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) => EpisodeOptions(episode: episode),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(currentEpisode);

    return episode.when(
      error: (error, stack) {
        if (kDebugMode) {
          print("TODO episode $error $stack");
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(child: Text(error.toString())),
        );
      },
      loading: () => const SizedBox.shrink(),
      data: (episode) {
        final hasBeenPlayed =
            ref.watch(playedEpisodesStateProvider).contains(episode.id);

        return EpisodeCard(
          hasBeenPlayed: hasBeenPlayed,
          imageUrl: episode.imageUrl,
          title: episode.title,
          audioFileUrl: episode.audioFileUrl,
          onPressed: () => onPressed(context, episode),
        );
      },
    );
  }
}
