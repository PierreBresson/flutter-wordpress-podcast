import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

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
  final HttpRepository httpRepository = HttpRepository();

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

  Widget displayLiveButton() {
    final app = dotenv.env['APP'];

    if (app == APP.causecommune.name) {
      return Center(
        child: InkWell(
          onTap: () async {
            //play direct
            final results = await httpRepository.getLiveBroadcastInfo();
            //https://icecast.libre-a-toi.org:8444/voixdulat_ssl
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Text(
              "Direct",
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      titleBar: const TitleBar(title: Text("Lecteur")),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Lecteur",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [displayLiveButton()],
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
