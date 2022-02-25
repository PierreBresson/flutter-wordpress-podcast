import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fwp/models/models.dart';
import 'package:intl/intl.dart';

class EpisodeDetails extends StatelessWidget {
  final Episode episode;

  const EpisodeDetails({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'fr';
    final DateTime dateTime = DateTime.parse(episode.date);
    final String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);

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
      body: SingleChildScrollView(
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
