import 'package:flutter/material.dart';

import 'package:stream_roulette/models/episode.dart';

class EpisodeSeasonDetails extends StatelessWidget {
  EpisodeSeasonDetails(this.episode);

  final Episode episode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String text = episode != null
        ? 'Season ' + episode.season.toString()
        + ', Episode ' + episode.episode.toString()
        : '';

    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Text(
        text,
//        style: Theme.of(context).textTheme.headline6,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}