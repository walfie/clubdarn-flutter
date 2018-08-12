import "package:flutter/foundation.dart";

enum SearchType { song, artist, series }

class SearchValues {
  String query = "";
  SearchType searchType = SearchType.song;
}

class Page<T> {
  const Page({
    @required this.page,
    @required this.artistCategoryId,
    this.seriesCategoryId,
    @required this.totalItems,
    @required this.totalPages,
    @required this.items,
  });

  final int page;
  final String artistCategoryId;
  final String seriesCategoryId;
  final int totalItems;
  final int totalPages;
  final List<T> items;
}

class Artist {
  const Artist({
    @required this.id,
    @required this.name,
  });

  final int id;
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

  final int id;
  final String title;
  final Artist artist;
  final String dateAdded;
  final String endDate;
  final String lyrics;
  final String series;
  final bool hasVideo;
}
