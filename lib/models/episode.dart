class Episode {
  String title;
  String description;
  int season;
  int episode;
  int overallEpisode;
  String streamUrl;
  String thumbnailUrl;

  Episode({this.title, this.description, this.season, this.episode, this.overallEpisode, this.streamUrl, this.thumbnailUrl});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        title: json['title'],
        description: json['description'],
        season: json['season'],
        episode: json['episode'],
        overallEpisode: json['overallEpisode'],
        streamUrl: json['streamUrl'],
        thumbnailUrl: json['thumbnailUrl']);
  }

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'description': description,
        'season': season,
        'episode': episode,
        'overallEpisode': overallEpisode,
        'streamUrl': streamUrl,
        'thumbnailUrl': thumbnailUrl,
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