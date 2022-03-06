// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/styles/styles.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const causeCommuneDescription =
    "Cause Commune rassemble dans sa grille de programmes les voix pour l’instant disparates des chercheurs et des inventeurs de solutions propres à relever les défis écologiques, techniques, sociaux et économiques du monde d’aujourd’hui. Pour ce faire, sont notamment invités à la rejoindre tous les acteurs du logiciel libre et du numérique, de la culture libre, de la science et de l’éducation, de l’environnement et de la nature qui oeuvrent pour le maintien et la sauvegarde des Biens Communs et pour une société de la Connaissance fondée sur le partage.";
const thinkerviewDescrption =
    "ThinkerView est un groupe indépendant issu d'internet, très diffèrent de la plupart des think-tanks qui sont inféodés à des partis politiques ou des intérêts privés";

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class LinkItem {
  final String title;
  final String link;

  LinkItem(this.title, this.link);

  LinkItem.fromJson(dynamic json)
      : title = json['title']! as String,
        link = json['link']! as String;
}

class _AboutScreenState extends State<AboutScreen> {
  String apptitle = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  List linksItems = [];
  int tapped = 0;
  final app = dotenv.env['APP'];

  Future<void> getInfoPackage() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentPackageName = packageInfo.packageName;

    final response =
        await rootBundle.loadString('assets/data/$currentPackageName.json');
    final Iterable data = await json.decode(response) as Iterable;
    final List<LinkItem> currentLinkItems =
        List<LinkItem>.from(data.map((model) => LinkItem.fromJson(model)));

    setState(() {
      linksItems = currentLinkItems;
      apptitle = packageInfo.appName;
      packageName = currentPackageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  Future<void> crashApp() async {
    throw Exception("This is a developer crash!");
  }

  @override
  void initState() {
    super.initState();
    getInfoPackage();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      titleBar: const TitleBar(title: Text("A propos")),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "A propos",
          style: FWPTypography(context).h6(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: renderLinks(),
      ),
    );
  }

  Widget renderLinks() {
    if (linksItems.isEmpty) {
      return const SizedBox.expand();
    }

    return ListView.builder(
      itemCount: linksItems.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                child: Text(
                  "Cette application open-source app a été conçu par Pierre Bresson de manière indépendante. N'hésitez pas à m'aider sur ko-fi.com et laisser un message ou bonne note à l'app pour encorager le développement de l'application!",
                  style: FWPTypography(context).body1(),
                ),
                onTap: () {
                  setState(() {
                    tapped = tapped + 1;
                  });
                },
              ),
              if (tapped > 10)
                ElevatedButton(
                  onPressed: crashApp,
                  child: Text(
                    "Crash app",
                    style: FWPTypography(context).body1(),
                  ),
                )
              else
                const SizedBox.shrink(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () => launch(
                    "https://www.google.fr/search?client=firefox-b-d&q=ko+fi+pierre+bresson",
                  ),
                  child: Text(
                    "Ko-fi Pierre Bresson",
                    style: FWPTypography(context).body1(),
                  ),
                ),
              ),
              if (app == APP.thinkerview.name)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.brown),
                    onPressed: () => launch(
                      Platform.isIOS
                          ? "https://docs.google.com/forms/d/e/1FAIpQLSfTR0BczGWN9WIeXfnK6BogAUW1ZP9WV-WDlPB7rLkwJSFPSg/viewform?usp=sf_link"
                          : "https://docs.google.com/forms/d/e/1FAIpQLSc0S2evuA0Klqoqyo5WNRcjUxm2J5asb0ASf5d0pRKBccwqOw/viewform?usp=sf_link",
                      forceSafariVC: false,
                    ),
                    child: const Text("Votre feedback sur l'app!"),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () => launch(
                    "https://github.com/PierreBresson/flutter-wordpress-podcast",
                  ),
                  child: Text(
                    "Github",
                    style: FWPTypography(context).body1(),
                  ),
                ),
              ),
              renderPodcastDescription(),
              ElevatedButton(
                child: Text(
                  linksItems[index].title as String,
                  style: FWPTypography(context).body1(),
                ),
                onPressed: () => launch(linksItems[index].link as String),
              ),
            ],
          );
        } else if (index == linksItems.length - 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  child: Text(
                    linksItems[index].title as String,
                    style: FWPTypography(context).body1(),
                  ),
                  onPressed: () => launch(linksItems[index].link as String),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    apptitle,
                    style: FWPTypography(context).body1(),
                  ),
                  Text(
                    " - ",
                    style: FWPTypography(context).body1(),
                  ),
                  Text(
                    packageName,
                    style: FWPTypography(context).body1(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version ",
                      style: FWPTypography(context).body1(),
                    ),
                    Text(
                      version,
                      style: FWPTypography(context).body1(),
                    ),
                    Text(
                      " - ",
                      style: FWPTypography(context).body1(),
                    ),
                    Text(
                      buildNumber,
                      style: FWPTypography(context).body1(),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              child: Text(
                linksItems[index].title as String,
                style: FWPTypography(context).body1(),
              ),
              onPressed: () => launch(linksItems[index].link as String),
            ),
          );
        }
      },
    );
  }

  Widget renderPodcastDescription() {
    var podcastDescription = "";

    if (app == APP.causecommune.name) {
      podcastDescription = causeCommuneDescription;
    } else if (app == APP.thinkerview.name) {
      podcastDescription = thinkerviewDescrption;
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          podcastDescription,
          style: FWPTypography(context).body1(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
