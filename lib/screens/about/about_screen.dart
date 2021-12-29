import 'package:flutter/material.dart';

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
              children: const [
                ElevatedButton(
                  onPressed: null,
                  child: Text("Faire un don"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: null,
                  child: Text("Github"),
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
              children: const [
                ElevatedButton(
                  onPressed: null,
                  child: Text("Faire un don"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: null,
                  child: Text("Site internet"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ElevatedButton(
                  onPressed: null,
                  child: Text("Youtube"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: null,
                  child: Text("Twitter"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
