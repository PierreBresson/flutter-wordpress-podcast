import 'package:flutter/material.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';
import 'package:macos_ui/macos_ui.dart';
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

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'fr';
    final DateTime dateTime = DateTime.parse(episode.date);
    final String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);
    final isDarkMode = isAppInDarkMode(context);

    if (episode.youtubeUrl == null) {
      return AdaptiveScaffold(
        titleBar: const TitleBar(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Header(
                dateformat: dateformat,
                episode: episode,
              ),
            ),
            const ErrorMessage(
              message: "Impossible de récupérer l'url youtube",
            )
          ],
        ),
      );
    } else {
      return AdaptiveScaffold(
        titleBar: const TitleBar(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
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
                          return Header(
                            dateformat: dateformat,
                            episode: episode,
                            statements: statements,
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "À ${Duration(seconds: statements[index - 1].time!).inHours}:${Duration(seconds: statements[index - 1].time!).inMinutes.remainder(60)}:${Duration(seconds: statements[index - 1].time!).inSeconds.remainder(60)}",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                statements[index - 1].text!,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(height: 20),
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
                  return const ErrorMessage();
                }
              } else {
                return const ErrorMessage();
              }
            }

            if (snapshot.hasError) {
              return const ErrorMessage();
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    }
  }
}

class Header extends StatelessWidget {
  final String dateformat;
  final Episode episode;
  final List<Statements>? statements;
  const Header({
    Key? key,
    required this.episode,
    required this.dateformat,
    this.statements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasStatements = statements != null && statements!.isNotEmpty;
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
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SizedBox(height: 20),
        if (episode.youtubeUrl != null)
          Column(
            children: [
              GestureDetector(
                onTap: () => launch("https://captainfact.io"),
                child: Row(
                  children: [
                    Text(
                      "Fact Checking - ",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "captainfact.io",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.link,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (hasStatements)
                const SizedBox.shrink()
              else
                const ErrorMessage(
                  message: "Aucun Fact Checking pour cet épisode",
                ),
            ],
          ),
      ],
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({
    Key? key,
    this.message = "Une erreur est survenue, essayer de nouveau plus tard",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
