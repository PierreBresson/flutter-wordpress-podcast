import 'package:flutter/material.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HttpRepository httpRepository = HttpRepository();
  List<Episode> episodes = [];
  bool hasError = false;

  Future<void> search(String searchText) async {
    try {
      final searchEpisodes = await httpRepository.searchEpisode(searchText);
      print(searchEpisodes);

      setState(() {
        episodes = searchEpisodes;
      });
    } catch (error) {
      hasError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Chercher un épisode",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => search(value),
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            renderResults(),
          ],
        ),
      ),
    );
  }

  Widget renderResults() {
    if (hasError) {
      return const Center(child: Text("toto"));
    }

    return Expanded(
      child: episodes.isNotEmpty
          ? ListView.builder(
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
            )
          : const Text(
              'No results found',
              style: TextStyle(fontSize: 24),
            ),
    );
  }
}
