import 'package:flutter/material.dart';

import 'package:stream_roulette/models/show.dart';

class HeaderTitle extends StatelessWidget {
  HeaderTitle(this.show);

  final Show show;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String imagePath = show != null
        ? 'assets/title_logos/${show.key}.png'
        : 'assets/title_logos/the_office.png';

    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: new Image.asset(imagePath, height: 70.0),
    );
  }
}