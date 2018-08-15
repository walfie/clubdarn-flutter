import "package:flutter/foundation.dart" hide Category;

enum SearchType { song, artist, series }

typedef T Deserializer<T>(Map<String, dynamic> object);

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

  Page.fromJson(
    Map<String, dynamic> json,
    Deserializer<T> deserializer,
  )   : artistCategoryId = json["artistCategoryId"],
        seriesCategoryId = json["seriesCategoryId"],
        items = List<Map<String, dynamic>>.from(json["items"])
            .map(deserializer)
            .toList();

  final String artistCategoryId;
  final String seriesCategoryId;
  final List<T> items;
}

class Artist {
  const Artist({
    @required this.id,
    @required this.name,
  });

  Artist.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

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
    this.hasVideo = false,
  });

  Song.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        artist = Artist.fromJson(json["artist"]),
        dateAdded = json["dateAdded"],
        endDate = json["endDate"],
        lyrics = json["lyrics"],
        series = json["series"],
        hasVideo = json["hasVideo"] == true;

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

  Series.fromJson(Map<String, dynamic> json) : title = json["title"];

  final String title;
}

class CategoryDescription {
  const CategoryDescription({
    @required this.en,
    @required this.ja,
  });

  CategoryDescription.fromJson(Map<String, dynamic> json)
      : en = json["en"],
        ja = json["ja"];

  final String en;
  final String ja;
}

class Category {
  const Category({
    @required this.id,
    @required this.description,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        description = CategoryDescription.fromJson(json["description"]);

  final String id;
  final CategoryDescription description;
}

class CategoryGroup {
  const CategoryGroup({
    @required this.description,
    @required this.categories,
  });

  CategoryGroup.fromJson(Map<String, dynamic> json)
      : description = CategoryDescription.fromJson(json["description"]),
        categories = List<Map<String, dynamic>>.from(json["categories"])
            .map((obj) => Category.fromJson(obj))
            .toList();

  final CategoryDescription description;
  final List<Category> categories;
}
