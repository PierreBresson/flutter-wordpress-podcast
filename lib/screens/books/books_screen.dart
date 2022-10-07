import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';

const bookUrl =
    'https://raw.githubusercontent.com/Killkitten/Thinkerview-Recommandations-lecture/master/README.md';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final _streamController = StreamController<String>();
  bool isLoading = false;
  final httpClient = HttpClient();

  @override
  void initState() {
    super.initState();
    httpClient.connectionTimeout = const Duration(seconds: 5);
    _fetchBooks();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = await httpClient.getUrl(Uri.parse(bookUrl));
      await request
          .close()
          .timeout(const Duration(seconds: 5))
          .then((HttpClientResponse response) {
        String markdown = "";

        if (response.statusCode != 200) {
          _streamController.sink.addError("Une erreur est survenue");
          setState(() {
            isLoading = false;
          });
          return;
        }

        final markdownStream = response.transform(const Utf8Decoder());

        markdownStream.listen((strings) {
          markdown = markdown + strings;
        }).onDone(() {
          _streamController.sink.add(markdown);
          setState(() {
            isLoading = false;
          });
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _streamController.sink.addError("Error while loading data");
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isAppInDarkMode(context);

    return AdaptiveScaffold(
      titleBar: TitleBar(
        title: Text(
          "Livres",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Livres",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
            onPressed: () => launchUrl(
              Uri.parse(
                "https://github.com/Killkitten/Thinkerview-Recommandations-lecture",
              ),
            ),
            icon: Icon(
              Icons.link,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: ErrorIndicator(
                  onTryAgain: _fetchBooks,
                ),
              );
            }

            if (snapshot.hasData) {
              return Markdown(data: snapshot.data ?? "");
            }

            return const Center(
              child: Text("Une erreur est survenue"),
            );
          },
        ),
      ),
    );
  }
}
