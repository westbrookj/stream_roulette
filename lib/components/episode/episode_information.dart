import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:stream_roulette/components/episode/episode_image.dart';
import 'package:stream_roulette/components/episode/episode_title.dart';
import 'package:stream_roulette/components/episode/episode_season_details.dart';
import 'package:stream_roulette/components/episode/episode_description.dart';
import 'package:stream_roulette/components/episode/episode_stream_link.dart';
import 'package:stream_roulette/models/episode.dart';


class EpisodeInformation extends StatelessWidget {
  EpisodeInformation(this.episode, this.episodeImage, this.loading);

  final Episode episode;
  final CachedNetworkImageProvider episodeImage;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loading == false
              ? <Widget>[
            EpisodeImage(episodeImage),
            EpisodeTitle(episode),
            EpisodeSeasonDetails(episode),
            EpisodeDescription(episode),
            EpisodeStreamLink(episode),
          ]
              : <Widget>[CircularProgressIndicator()],
        )
    );
  }
}