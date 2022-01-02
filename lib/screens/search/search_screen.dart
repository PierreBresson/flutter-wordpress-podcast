import 'package:flutter/material.dart';
import "package:flutter/scheduler.dart";
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';

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
  bool isDarkMode = false;

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
        episodes = searchEpisodes;
        isLoading = false;
        hasUserStartedSearching = true;
      });
    } catch (error) {
      hasError = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: renderTitle(),
        actions: <Widget>[
          IconButton(
            icon: isSearchViewClicked
                ? const Icon(
                    Icons.close,
                    color: Colors.white,
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

  Widget renderTitle() {
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

    if (isSearchViewClicked) {
      return TextField(
        focusNode: focusNode,
        // style: const TextStyle(color: Colors.black),
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
          // hintStyle: const TextStyle(color: Colors.black54),
          icon: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              // color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSearchViewClicked = false;
              });
            },
          ),
        ),
        autofocus: true,
        // cursorColor: Colors.black,
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

    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (context, index) => EpisodeCard(
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
      ),
    );
  }
}
