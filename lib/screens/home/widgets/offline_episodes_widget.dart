import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fwp/i18n.dart';
import 'package:fwp/models/models.dart';
import 'package:fwp/providers/providers.dart';
import 'package:fwp/screens/home/widgets/widgets/offline_episodes_downloaded_widget.dart';
import 'package:fwp/screens/home/widgets/widgets/offline_episodes_downloading_widget.dart';
import 'package:fwp/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwp/screens/home/widgets/widgets/widgets.dart';
import 'package:fwp/i18n.dart';

enum EpisodesTabs { downloaded, inDownload }

Map<EpisodesTabs, Color> skyColors = <EpisodesTabs, Color>{
  EpisodesTabs.downloaded: const Color(0xff191970),
  EpisodesTabs.inDownload: const Color(0xff40826d),
};

class OfflineEpisodes extends ConsumerStatefulWidget {
  const OfflineEpisodes({
    super.key,
  });

  @override
  OfflineEpisodesState createState() => OfflineEpisodesState();
}

class OfflineEpisodesState extends ConsumerState<OfflineEpisodes> {
  EpisodesTabs _selectedSegment = EpisodesTabs.downloaded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Center(
            child: CupertinoSlidingSegmentedControl<EpisodesTabs>(
              groupValue: _selectedSegment,
              onValueChanged: (EpisodesTabs? value) {
                if (value != null) {
                  setState(() {
                    _selectedSegment = value;
                  });
                }
              },
              children: <EpisodesTabs, Widget>{
                EpisodesTabs.downloaded: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.offline_episodes_widget_downloaded.tr(),
                  ),
                ),
                EpisodesTabs.inDownload: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.offline_episodes_widget_in_download.tr(),
                  ),
                ),
              },
            ),
          ),
        ),
        if (_selectedSegment == EpisodesTabs.downloaded) ...[
          const Expanded(
            child: OfflineEpisodesDownloaded(),
          ),
        ] else ...[
          const Expanded(
            child: OfflineEpisodesDownloading(),
          ),
        ],
      ],
    );
  }
}
