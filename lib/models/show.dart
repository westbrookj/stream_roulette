import 'package:stream_roulette/models/episode.dart';
import 'package:flutter/material.dart';

class Show {
  String key;
  String title;
  Color headerColor;
  Map<int, Episode> episodes;

  Show({this.key, this.title, this.headerColor, this.episodes});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
        key: json['key'],
        title: json['title'],
        headerColor: Color(int.parse(json['headerColor'])),
        episodes: Episode.fromJsonList(json['episodes']),
    );
  }

  static Map<String, Show> fromJsonList(List<dynamic> json) {
    Map<String, Show> shows = new Map<String, Show>();

    for(Map<String, dynamic> showJson in json) {
      var showKey = showJson['key'];
      Show show = Show.fromJson(showJson);
      shows[showKey] = show;
    }

    return shows;
  }
}