import 'package:flutter/foundation.dart';

enum SearchType { song, artist, series }

class SearchValues {
  String query = "";
  SearchType searchType = SearchType.song;
}

class Artist {
  const Artist({
    @required this.id,
    @required this.name,
  });

  final num id;
  final String name;
}

class Song {
  const Song({
    @required this.id,
    @required this.title,
    @required this.artist,
    this.dateAdded,
    this.endDate,
    this.lyrics,
    this.series,
    this.hasVideo,
  });

  final num id;
  final String title;
  final Artist artist;
  final String dateAdded;
  final String endDate;
  final String lyrics;
  final String series;
  final bool hasVideo;
}
