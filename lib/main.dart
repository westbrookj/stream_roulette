import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class Episode {
  String title;
  String description;
  int season;
  int episode;
  String netflixUrl;

  Episode({this.title, this.description, this.season, this.episode, this.netflixUrl});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        title: json['title'],
        description: json['description'],
        season: json['season'],
        episode: json['episode'],
        netflixUrl: json['netflixUrl']);
  }

  Map<String, dynamic> toJson() =>
    {
      'title': title,
      'description': description,
      'season': season,
      'episode': episode,
      'netflixUrl': netflixUrl,
    };

  @override
  String toString() => title + ': S' + season.toString() + 'E' + episode.toString();

  static Map<int, Episode> fromJsonList(List<dynamic> json) {
    Map<int, Episode> episodes = new Map<int, Episode>();

    for(Map<String, dynamic> episodeJson in json) {
      var episodeNumber = episodeJson['overallEpisode'];
      Episode episode = Episode.fromJson(episodeJson);
      episodes[episodeNumber] = episode;
    }

    return episodes;
  }
}

Future<String> _loadEpisodesAsset() async {
  return await rootBundle.loadString('assets/episodes.json');
}

Future<Map<int, Episode>> loadEpisodes() async {
  String jsonString = await _loadEpisodesAsset();
  final jsonResponse = json.decode(jsonString);
  return Episode.fromJsonList(jsonResponse);
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Office Roulette',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'The Office Roulette'),
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
  Map<int, Episode> _episodes;
  Episode _currentEpisode;
  int _currentEpisodeNumber;

  @override
  void initState() {
    super.initState();
    loadEpisodes().then((episodes) => setState(() {
      _episodes = episodes;
    }));
  }

  Container _currentEpisodeTitle() {
    String text = _currentEpisode != null
        ? _currentEpisode.title
        : 'Press "Pick Next Episode" to see what episode you\'re watching tonight!';

    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      margin: _currentEpisode == null
          ? new EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0)
          : null,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Container _currentEpisodeSeasonEpisode() {
    String text = _currentEpisode != null
        ? 'Season ' + _currentEpisode.season.toString()
          + ', Episode ' + _currentEpisode.episode.toString()
        : '';

    return Container(
      padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Container _currentEpisodeDescription() {
    String text = _currentEpisode != null ? _currentEpisode.description : '';

    return Container(
      padding: new EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      height: 100.0,
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  InkWell _currentEpisodeNetflixLink() {
    return InkWell(
      onTap: _launchNetflix,
      child: Container(
        child: _currentEpisode != null
            ? Image.asset('assets/netflix_icon.png', width: 75.0, height: 75.0)
            : null,
      ),
    );
  }

  Image _getCurrentEpisodeImage() {
    return _currentEpisodeNumber != null
        ? Image.asset('assets/thumbnails/' + _currentEpisodeNumber.toString() + '.png')
        : null;
  }

  void _launchNetflix() {
    if (_currentEpisode != null) {
      launch(_currentEpisode.netflixUrl);
    }
  }

  void _nextEpisode() {
    Random random = new Random();
    int episodeNumber = random.nextInt(_episodes.length + 1);

    while (episodeNumber == _currentEpisodeNumber || episodeNumber == 0) {
      episodeNumber = random.nextInt(_episodes.length + 1);
    }

    setState(() {
      _currentEpisode = _episodes[episodeNumber];
      _currentEpisodeNumber = episodeNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xff20255e),
        title: Container(
          alignment: Alignment.center,
          margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Image.asset('assets/the_office_title_logo.png', height: 70.0),
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 192.0,
                    child: _getCurrentEpisodeImage(),
                  ),
                  _currentEpisodeTitle(),
                  _currentEpisodeSeasonEpisode(),
                  _currentEpisodeDescription(),
                  _currentEpisodeNetflixLink(),
                ]
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: new EdgeInsets.only(bottom: 50.0),
                child: RaisedButton(
                  onPressed: _nextEpisode,
                  child: const Text('Pick Next Episode', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
