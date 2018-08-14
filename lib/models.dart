import "package:flutter/foundation.dart" hide Category;

enum SearchType { song, artist, series }

class SearchValues {
  String query = "";
  SearchType searchType = SearchType.song;
}

class Page<T> {
  const Page({
    @required this.artistCategoryId,
    this.seriesCategoryId,
    @required this.items,
  });

  final String artistCategoryId;
  final String seriesCategoryId;
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

class Series {
  const Series({@required this.title});
  final String title;
}

class CategoryDescription {
  const CategoryDescription({
    @required this.en,
    @required this.ja,
  });

  final String en;
  final String ja;
}

class Category {
  const Category({
    @required this.id,
    @required this.description,
  });

  final String id;
  final CategoryDescription description;
}

class CategoryGroup {
  const CategoryGroup({
    @required this.description,
    @required this.categories,
  });

  final CategoryDescription description;
  final List<Category> categories;
}
