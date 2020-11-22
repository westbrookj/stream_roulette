import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;

import 'package:stream_roulette/components/episode/episode_information.dart';
import 'package:stream_roulette/components/header/header_title.dart';
import 'package:stream_roulette/components/next_episode_button.dart';
import 'package:stream_roulette/components/show_dropdown.dart';
import 'package:stream_roulette/models/episode.dart';
import 'package:stream_roulette/models/show.dart';

Future<Map<String, Show>> loadShows() async {
  final response = await http.get('https://westbrookj.github.io/stream-roulette/shows.json');
  final jsonResponse = json.decode(response.body);
  return Show.fromJsonList(jsonResponse);
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Roulette',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stream Roulette'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Show> _shows;
  bool _loading = true;
  bool _loadingEpisode = false;
  Show _currentShow;
  Episode _currentEpisode;
  NetworkImage _currentEpisodeImage;

  @override
  void initState() {
    super.initState();

    loadShows().then((shows) => setState(() {
      _shows = shows;
      _currentShow = shows['the_office'];
      _loading = false;
    }));
  }

  void _setShow(String showKey) {
    setState(() {
      _currentShow = _shows[showKey];
      _currentEpisode = null;
      _currentEpisodeImage = null;
    });
  }

  void _nextEpisode() {
    Random random = new Random();
    int episodeNumber = random.nextInt(_currentShow.episodes.length + 1);

    while (_currentEpisode != null && episodeNumber == _currentEpisode.overallEpisode || episodeNumber == 0) {
      episodeNumber = random.nextInt(_currentShow.episodes.length + 1);
    }

    setState(() {
      _currentEpisode = _currentShow.episodes[episodeNumber];
      _currentEpisodeImage = NetworkImage(_currentShow.episodes[episodeNumber].thumbnailUrl);
      _loadingEpisode = true;
    });

    _currentEpisodeImage.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((info, call) {
          setState(() {
            _loadingEpisode = false;
          });
        })
    );
  }

  List<Widget> _pageContent() {
    return _loading == false
      ? <Widget>[
        ShowDropdown(_shows, _currentShow, _setShow),
        EpisodeInformation(_currentEpisode, _currentEpisodeImage, _loadingEpisode),
        NextEpisodeButton(_nextEpisode),
      ] : <Widget>[CircularProgressIndicator()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: _currentShow?.headerColor ?? const Color(0xff20255e),
        title: HeaderTitle(_currentShow),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _pageContent(),
        ),
      ),
    );
  }
}
