import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EpisodeImage extends StatelessWidget {
  EpisodeImage(this.image);

  final CachedNetworkImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192.0,
      decoration: image != null ? BoxDecoration(
        image: DecorationImage(image: image),
      ): null,
    );
  }
}