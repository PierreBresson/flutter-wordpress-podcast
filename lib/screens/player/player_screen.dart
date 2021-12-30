import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fwp/blocs/blocs.dart';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Lecteur",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocBuilder<PlayerCubit, PlayerState>(
        builder: (context, player) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: renderImage(player),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        player.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: const [
                  AudioProgressBar(),
                  AudioControlButtons(),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image renderImage(PlayerState player) {
    final app = dotenv.env['APP'];
    String imageUri = "";

    if (app == "Thinkerview") {
      imageUri = 'assets/images/thinkerview.png';
    } else if (app == "CauseCommune") {
      imageUri = 'assets/images/cause-commune.png';
    }

    if (player.imageUrl.isEmpty) {
      return Image(
        image: AssetImage(
          imageUri,
        ),
      );
    }

    return Image(image: NetworkImage(player.imageUrl));
  }
}
