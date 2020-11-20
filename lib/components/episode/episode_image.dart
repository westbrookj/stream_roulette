import 'package:flutter/material.dart';

class EpisodeImage extends StatelessWidget {
  EpisodeImage(this.image);

  final NetworkImage image;

  // This widget is the root of your application.
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