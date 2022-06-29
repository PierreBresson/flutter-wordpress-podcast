//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:audio_service_web/audio_service_web.dart';
import 'package:audio_session/audio_session_web.dart';
import 'package:just_audio_web/just_audio_web.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:sentry_flutter/sentry_flutter_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:wakelock_web/wakelock_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  AudioServiceWeb.registerWith(registrar);
  AudioSessionWeb.registerWith(registrar);
  JustAudioPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  SentryFlutterWeb.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  WakelockWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
