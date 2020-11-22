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

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (episode != null) {
      String regexString = r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)\..*';
      RegExp regExp = new RegExp(regexString);
      var streamProvider = regExp.firstMatch(episode.streamUrl).group(1);
      imagePath = 'https://westbrookj.github.io/stream-roulette/api/icons/$streamProvider.png';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        child: episode != null
            ? Image.network(imagePath, width: 75.0, height: 75.0)
            : null,
      ),
    );
  }
}