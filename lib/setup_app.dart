import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fwp/navigation/router.dart';
import 'package:fwp/repositories/repositories.dart';
import 'package:just_audio/just_audio.dart';

import 'app.dart';

Future<void> setupApp() async {
  final _trackingRepository = TrackingRepository();
  final _router = createRouter(trackingRepository: _trackingRepository);

  runApp(
    RepositoryProvider(
      create: (_) => AudioPlayer(),
      child: FwpApp(
        router: _router,
      ),
    ),
  );
}
