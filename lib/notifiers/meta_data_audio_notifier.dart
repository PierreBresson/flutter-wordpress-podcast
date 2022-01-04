import 'package:flutter/foundation.dart';

class MetaDataAudioNotifier extends ValueNotifier<MetaDataAudioState> {
  MetaDataAudioNotifier() : super(_initialValue);
  static final _initialValue = MetaDataAudioState(
    artUri: Uri(path: ""),
    title: "",
  );
}

class MetaDataAudioState {
  const MetaDataAudioState({
    required this.artUri,
    required this.title,
  });
  final Uri artUri;
  final String title;
}
