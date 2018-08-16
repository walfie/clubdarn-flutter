import "dart:async";
import "dart:convert";

import "package:flutter/foundation.dart" hide Category;
import 'package:http/http.dart' as http;

import "models.dart";

class Searcher {
  Searcher({
    @required this.baseUrl = "https://clubdarn.aikats.us/api",
    this.serialNo,
  });

  String baseUrl;
  String serialNo;

  Future<Page<T>> _getPage<T>(
    String url,
    Map<String, String> queryParameters,
    Deserializer<T> deserializer,
  ) async {
    // serial_no can be null, in which case we remove it
    queryParameters.removeWhere((k, v) => v == null);

    final uri = Uri.tryParse(url).replace(queryParameters: queryParameters);

    final response = await http.get(uri);
    if (response.statusCode >= 300) {
      throw Exception("${response.statusCode} error: ${response.body}");
    }

    final jsonBody = json.decode(utf8.decode(response.bodyBytes));

    return Page.fromJson(jsonBody, deserializer);
  }

  Future<Page<Song>> getSongsByTitle(String title) async {
    return await _getPage<Song>(
      "$baseUrl/songs/",
      {"title": title, "serial_no": serialNo},
      (j) => Song.fromJson(j),
    );
  }

  Future<Page<Artist>> getArtistsByName(String name) async {
    return await _getPage<Artist>(
      "$baseUrl/artists/",
      {"name": name, "serial_no": serialNo},
      (j) => Artist.fromJson(j),
    );
  }

  Future<Page<Song>> getSongsByArtistId(int id) async {
    return await _getPage<Song>(
      "$baseUrl/artists/$id/songs",
      {"serial_no": serialNo},
      (j) => Song.fromJson(j),
    );
  }

  Future<Page<Series>> getSeriesByTitle(String title) async {
    return await _getPage<Series>(
      "$baseUrl/series/",
      {"title": title, "serial_no": serialNo},
      (j) => Series.fromJson(j),
    );
  }

  Future<Page<CategoryGroup>> getCategories() async {
    // TODO: Add special "Music Video" category
    final page = await _getPage<CategoryGroup>(
      "$baseUrl/categories",
      {"serial_no": serialNo},
      (j) => CategoryGroup.fromJson(j),
    );

    // For whatever reason, this isn't returned by the API.
    // I probably had a reason for that, but I don't remember why.
    const additionalGroup = CategoryGroup(
      description: CategoryDescription(en: "Series", ja: "アニメ･特撮"),
      categories: [
        Category(
          id: "050300",
          description: CategoryDescription(
            en: "Music Video",
            ja: "映像",
          ),
        ),
      ],
    );

    for (var group in page.items) {
      group.categories
          .sort((c1, c2) => c1.description.en.compareTo(c2.description.en));
    }

    page.items.add(additionalGroup);
    return page;
  }

  Future<Page<Song>> getSongsForCategoryId(String categoryId) async {
    return await _getPage<Song>(
      "$baseUrl/categories/$categoryId/songs",
      {"serial_no": serialNo},
      (j) => Song.fromJson(j),
    );
  }

  Future<Page<Song>> getSongsForSeries(String seriesTitle,
      {String categoryId = "050100"}) async {
    return await _getPage<Song>(
      "$baseUrl/categories/$categoryId/series/${Uri.encodeComponent(seriesTitle)}/songs",
      {"serial_no": serialNo},
      (j) => Song.fromJson(j),
    );
  }
}
