import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stream_roulette/models/episode.dart';

class EpisodeStreamLink extends StatelessWidget {
  EpisodeStreamLink(this.episode);

  final Episode episode;

  void onTap() {
    if (episode != null) {
      launch(episode.streamUrl);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (episode != null) {
      if (episode.streamUrl.contains('netflix')) {
        imagePath = 'assets/icons/netflix.png';
      } else if (episode.streamUrl.contains('hulu')) {
        imagePath = 'assets/icons/hulu.png';
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        child: episode != null
            ? Image.asset(imagePath, width: 75.0, height: 75.0)
            : null,
      ),
    );
  }
}