import 'package:stream_roulette/models/episode.dart';
import 'package:flutter/material.dart';

class Show {
  String key;
  String display;
  Color headerColor;
  Map<int, Episode> episodes;

  Show(String key, String display, Color headerColor) {
    this.key = key;
    this.display = display;
    this.headerColor = headerColor;
  }

  void setEpisodes(Map<int, Episode> episodes) {
    this.episodes = episodes;
  }
}