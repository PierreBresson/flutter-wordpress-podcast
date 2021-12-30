import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
                  onPressed: () =>
                      launch("https://www.youtube.com/thinkerview"),
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
                  onPressed: () =>
                      launch("https://www.facebook.com/Thinkerview/"),
                  child: const Text("Facebook"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () =>
                      launch("https://captainfact.io/s/Thinkerview"),
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
        ),
      ),
    );
  }
}
