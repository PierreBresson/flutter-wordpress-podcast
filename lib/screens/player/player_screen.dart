import 'package:flutter/material.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

const iconPlaySize = 60.0;

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
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
      titleBar: TitleBar(
        title: Text(
          "Lecteur",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: GestureDetector(
          onTap: () {
            // ignore: avoid_print
            print("toto");
            // ignore: avoid_print
            print(ref.watch(currentEpisodePlayableProvider)?.positionInSeconds);
          },
          child: Text(
            "Lecteur",
            style: Theme.of(context).textTheme.headline6,
          ),
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
