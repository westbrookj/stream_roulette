import 'package:flutter/material.dart';

import 'package:stream_roulette/models/show.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeaderTitle extends StatelessWidget {
  HeaderTitle(this.show);

  final Show show;

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'https://westbrookj.github.io/stream-roulette/api/title_logos/${show?.key ?? 'the_office'}.png';

    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: CachedNetworkImage(
          imageUrl: imageUrl, height: 70.0),
    );
  }
}