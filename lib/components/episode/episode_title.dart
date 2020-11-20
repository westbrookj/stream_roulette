import 'package:flutter/material.dart';

import 'package:stream_roulette/models/episode.dart';

class EpisodeTitle extends StatelessWidget {
  EpisodeTitle(this.episode);

  final Episode episode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String text = episode != null
        ? episode.title
        : 'Press "Pick Next Episode" to see what episode you\'re watching tonight!';

    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Text(
        text,
//        style: Theme.of(context).textTheme.headline5,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}