import 'package:flutter/material.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';

const iconPlaySize = 60.0;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final PlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    _playerManager = PlayerManager();
  }

  @override
  void dispose() {
    _playerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Lecteur",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const AudioMetaData(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                AudioProgressBar(),
                AudioControlButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
