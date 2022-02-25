import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final _httpLink = HttpLink('https://graphql.captainfact.io/');
const String readVideoData = r'''
  query redVideoData($youtubeUrl: String) {
    video(url: $youtubeUrl) {
      id
      statements {
        text
        time
        comments {
          replyToId
          score
          text
          approve
          source {
            url
          }
        }
      }
    }
  }
''';
// for dev debug, instead of episode.youtubeUrl you can use this one below
// const youtubeUrl = "https://www.youtube.com/watch?v=xx3PsG2mr-Y&feature=emb_title";

class EpisodeDetailsCaptainFact extends StatelessWidget {
  final Episode episode;

  EpisodeDetailsCaptainFact({Key? key, required this.episode})
      : super(key: key);

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: _httpLink,
  );

  Future<QueryResult> getVideoData(String youtubeUrl) {
    final QueryOptions options = QueryOptions(
      document: gql(readVideoData),
      variables: <String, dynamic>{
        'youtubeUrl': youtubeUrl,
      },
    );
    return client.query(options);
  }

  Widget renderError() {
    return const Center(
      child: Text("Une erreur est survenue lors du chargement."),
    );
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'fr';
    final DateTime dateTime = DateTime.parse(episode.date);
    final String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);

    if (episode.youtubeUrl == null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: renderHeader(context, dateformat),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
        body: FutureBuilder(
          future: getVideoData(episode.youtubeUrl!),
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            if (snapshot.hasData) {
              final Map<String, dynamic>? data = snapshot.data?.data;
              if (data != null) {
                final statements =
                    CaptainFactData.fromJson(data).video?.statements;
                if (statements != null) {
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView.builder(
                      itemCount: statements.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return renderHeader(context, dateformat);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            children: [
                              Text(statements[index - 1].text!),
                              const SizedBox(height: 10),
                              CaptainFactGrades(
                                comments: statements[index - 1].comments,
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return renderError();
                }
              } else {
                return renderError();
              }
            }

            if (snapshot.hasError) {
              return renderError();
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    }
  }

  Column renderHeader(BuildContext context, String dateformat) {
    return Column(
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
        if (episode.youtubeUrl != null)
          Column(
            children: [
              Text(
                "Fact Checking - Captain Fact",
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () => launch("https://captainfact.io"),
                child: const Text("Site Captain Fact"),
              ),
              const SizedBox(height: 30),
            ],
          ),
      ],
    );
  }
}
