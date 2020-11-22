import 'package:flutter/material.dart';

import 'package:stream_roulette/models/episode.dart';

class EpisodeDescription extends StatelessWidget {
  EpisodeDescription(this.episode);

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    String text = episode != null ? episode.description : '';

    return Container(
      padding: new EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      height: 125.0,
      child: SingleChildScrollView(
        child: Text(
          text,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}