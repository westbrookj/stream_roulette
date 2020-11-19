import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

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

class Episode {
  String title;
  String description;
  int season;
  int episode;
  int overallEpisode;
  String streamUrl;

  Episode({this.title, this.description, this.season, this.episode, this.overallEpisode, this.streamUrl});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        title: json['title'],
        description: json['description'],
        season: json['season'],
        episode: json['episode'],
        overallEpisode: json['overallEpisode'],
        streamUrl: json['streamUrl']);
  }

  Map<String, dynamic> toJson() =>
    {
      'title': title,
      'description': description,
      'season': season,
      'episode': episode,
      'overallEpisode': overallEpisode,
      'streamUrl': streamUrl,
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

Future<String> _loadEpisodesAsset(String showName) async {
  return await rootBundle.loadString('assets/episodes/$showName.json');
}

Future<Map<int, Episode>> loadEpisodes(String showName) async {
  String jsonString = await _loadEpisodesAsset(showName);
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
  Show _currentShow;
  Episode _currentEpisode;

  Future<Map<String, Show>> _loadShows() async {
    Map<String, Show> shows = {
      "the_office": new Show('the_office', 'The Office', const Color(0xff20255e)),
      "futurama": new Show('futurama', 'Futurama', const Color(0xff57afe1)),
      "trailer_park_boys": new Show('trailer_park_boys', 'Trailer Park Boys', const Color(0xffc3c3c3)),
      "new_girl": new Show('new_girl', 'New Girl', const Color(0xff1d61b0)),
    };

    for(var showKey in shows.keys) {
      shows[showKey].setEpisodes(await loadEpisodes(showKey));
    }

    return shows;
  }

  @override
  void initState() {
    super.initState();

    _loadShows().then((shows) => setState(() {
      _shows = shows;
      _currentShow = shows['the_office'];
      _loading = false;
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
//        style: Theme.of(context).textTheme.headline5,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
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
//        style: Theme.of(context).textTheme.headline6,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
    );
  }

  Container _currentEpisodeDescription() {
    String text = _currentEpisode != null ? _currentEpisode.description : '';

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

  InkWell _currentEpisodeStreamLink() {
    String imagePath;
    if (_currentEpisode != null) {
      if (_currentEpisode.streamUrl.contains('netflix')) {
        imagePath = 'assets/icons/netflix.png';
      } else if (_currentEpisode.streamUrl.contains('hulu')) {
        imagePath = 'assets/icons/hulu.png';
      }
    }

    return InkWell(
      onTap: _launchStream,
      child: Container(
        child: _currentEpisode != null
            ? Image.asset(imagePath, width: 75.0, height: 75.0)
            : null,
      ),
    );
  }

  Image _getCurrentEpisodeImage() {
    return _currentEpisode != null
        ? Image.asset('assets/thumbnails/${_currentShow.key}/' + _currentEpisode.overallEpisode.toString() + '.png')
        : null;
  }

  void _launchStream() {
    if (_currentEpisode != null) {
      launch(_currentEpisode.streamUrl);
    }
  }

  void _setShow(String showKey) {
    setState(() {
      _currentShow = _shows[showKey];
      _currentEpisode = null;
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
    });
  }

  Color _headerBackgroundColor() {
    return _currentShow != null
        ? _currentShow.headerColor
        : const Color(0xff20255e);
  }

  Container _headerTitle() {
    String imagePath = _currentShow != null
        ? 'assets/title_logos/${_currentShow.key}.png'
        : 'assets/title_logos/the_office.png';
    return Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      child: new Image.asset(imagePath, height: 70.0),
    );
  }

  List<Widget> _pageContent() {
    return _loading == false
      ? <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: new EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                child: FloatingActionButton.extended(
                    icon: Icon(
                      Icons.tv,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    backgroundColor: Color(0xffe0e0e0),
                    label: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        underline: null,
                        value: _currentShow != null ? _currentShow.key : null,
                        items: _shows != null
                            ? _shows.values.map((show) {
                          return DropdownMenuItem(
                            value: show.key,
                            child: Text(show.display, style: TextStyle(color: Colors.black)),
                          );
                        }).toList()
                            : new List<DropdownMenuItem>(),
                        onChanged: (showKey) => _setShow(showKey),
                      )
                    ),
                ),
            )
        ),
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
                  _currentEpisodeStreamLink(),
                ]
            )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: new EdgeInsets.only(bottom: 35.0),
            child: RaisedButton(
              onPressed: _nextEpisode,
              child: const Text('Pick Next Episode', style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ] : <Widget>[CircularProgressIndicator()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: _headerBackgroundColor(),
        title: _headerTitle(),
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
