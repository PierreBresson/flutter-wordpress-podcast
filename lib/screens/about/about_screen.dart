import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);
  final app = dotenv.env['APP'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "A propos",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
        child: Column(
          children: [
            const Text(
              "Cette application open-source app a été conçu par Pierre Bresson.",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => launch("https://ko-fi.com/pierrebresson"),
                  child: const Text("Faire un don"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => launch(
                    "https://github.com/PierreBresson/flutter-wordpress-podcast",
                  ),
                  child: const Text("Github"),
                ),
              ],
            ),
            renderThinkerview(),
            renderCauseCommune(),
          ],
        ),
      ),
    );
  }

  Widget renderThinkerview() {
    if (app != "Thinkerview") {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          "ThinkerView est un groupe indépendant issu d'internet, très diffèrent de la plupart des think-tanks qui sont inféodés à des partis politiques ou des intérêts privés",
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://tipeee.com/thinkerview"),
              child: const Text("Faire un don"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => launch("https://www.thinkerview.com/"),
              child: const Text("Site internet"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://www.youtube.com/thinkerview"),
              child: const Text("Youtube"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => launch("https://twitter.com/Thinker_View"),
              child: const Text("Twitter"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://www.facebook.com/Thinkerview/"),
              child: const Text("Facebook"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => launch("https://captainfact.io/s/Thinkerview"),
              child: const Text("CaptainFact"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://mamot.fr/@thinkerview"),
              child: const Text("Mastodon"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => launch("https://videos.thinkerview.com/"),
              child: const Text("Peertube"),
            ),
          ],
        ),
      ],
    );
  }

  Widget renderCauseCommune() {
    if (app != "CauseCommune") {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          "Cause Commune rassemble dans sa grille de programmes les voix pour l’instant disparates des chercheurs et des inventeurs de solutions propres à relever les défis écologiques, techniques, sociaux et économiques du monde d’aujourd’hui. Pour ce faire, sont notamment invités à la rejoindre tous les acteurs du logiciel libre et du numérique, de la culture libre, de la science et de l’éducation, de l’environnement et de la nature qui oeuvrent pour le maintien et la sauvegarde des Biens Communs et pour une société de la Connaissance fondée sur le partage.",
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://cause-commune.fm/faire-un-don/"),
              child: const Text("Faire un don"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => launch("https://cause-commune.fm/"),
              child: const Text("Site internet"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  launch("https://www.facebook.com/causecommune93.1/"),
              child: const Text("Facebook"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () =>
                  launch("https://www.instagram.com/causecommune93.1/"),
              child: const Text("Instagram"),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => launch("https://twitter.com/_CauseCommune_"),
              child: const Text("Twitter"),
            ),
          ],
        )
      ],
    );
  }
}
