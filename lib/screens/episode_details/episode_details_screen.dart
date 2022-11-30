import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fwp/models/models.dart';
import 'package:intl/intl.dart';

class EpisodeDetails extends StatelessWidget {
  const EpisodeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Episode episode =
        Beamer.of(context).currentBeamLocation.data! as Episode;
    final DateTime dateTime = DateTime.parse(episode.date);
    final String dateformat = DateFormat.yMMMMEEEEd().format(dateTime);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
