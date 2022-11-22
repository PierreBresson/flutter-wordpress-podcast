import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode focusNode = FocusNode();
  final HttpRepository httpRepository = HttpRepository();
  List<Episode> episodes = [];
  String query = "";
  bool hasError = false;
  bool hasUserStartedSearching = false;
  bool isLoading = true;
  bool isSearchViewClicked = false;

  Future<void> search(String searchText) async {
    if (searchText.isEmpty) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final ids = await httpRepository.search(searchText);
      final searchEpisodes = await httpRepository.getEpisodesByIds(ids);

      setState(() {
        isLoading = false;
        hasUserStartedSearching = true;
        episodes = searchEpisodes;
      });
    } catch (error) {
      hasError = true;
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          isSearchViewClicked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isAppInDarkMode(context);

    return AdaptiveScaffold(
      titleBar: TitleBar(title: renderTitle(isDarkMode: isDarkMode)),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: renderTitle(isDarkMode: isDarkMode),
        actions: <Widget>[
          IconButton(
            icon: isSearchViewClicked
                ? Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )
                : const SizedBox.shrink(),
            onPressed: () {
              setState(() {
                if (isSearchViewClicked) {
                  isSearchViewClicked = false;
                } else {
                  isSearchViewClicked = true;
                }
              });
            },
          )
        ],
      ),
      body: episodes.isNotEmpty ? renderResults() : renderNoSearchResult(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isSearchViewClicked = true;
          });
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget renderTitle({required bool isDarkMode}) {
    if (!isSearchViewClicked &&
        episodes.isNotEmpty &&
        hasUserStartedSearching) {
      if (query.isEmpty) {
        return Text(
          'Résultats',
          style: Theme.of(context).textTheme.headline6,
        );
      }

      return Text(
        'Résultats pour "$query"',
        style: Theme.of(context).textTheme.headline6,
      );
    }

    if (Platform.isMacOS) {
      return MacosTextField(
        prefix: const Icon(
          Icons.search,
          size: 20,
        ),
        placeholder: "Chercher ici",
        placeholderStyle: TextStyle(color: Colors.grey[500]),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        autofocus: true,
        textInputAction: TextInputAction.search,
        focusNode: focusNode,
        onSubmitted: (value) {
          isSearchViewClicked = false;
          setState(() {
            query = value;
          });
          search(value);
        },
      );
    }

    if (isSearchViewClicked) {
      return TextField(
        focusNode: focusNode,
        onSubmitted: (value) {
          isSearchViewClicked = false;
          setState(() {
            query = value;
          });
          search(value);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Chercher',
          icon: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              setState(() {
                isSearchViewClicked = false;
              });
            },
          ),
        ),
        autofocus: true,
      );
    }

    return Text(
      "Chercher un épisode",
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget renderNoSearchResult() {
    if (hasUserStartedSearching) {
      return const Center(
        child: Text(
          'Aucun résultat',
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget renderResults() {
    if (hasError) {
      return const Center(child: Text("Une erreur est survenue"));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return HookConsumer(
      builder: (context, ref, child) {
        return ListView.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final hasBeenPlayed = ref
                .watch(playedEpisodesStateProvider)
                .contains(episodes[index].id);

            return EpisodeCard(
              hasBeenPlayed: hasBeenPlayed,
              imageUrl: episodes[index].imageUrl,
              title: episodes[index].title,
              audioFileUrl: episodes[index].audioFileUrl,
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
                      EpisodeOptions(episode: episodes[index]),
                );
              },
            );
          },
        );
      },
    );
  }
}
