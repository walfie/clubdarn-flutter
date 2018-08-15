import "dart:async";
import "dart:convert";
import "dart:math"; // TODO: Remove when Random is not needed

import "package:flutter/foundation.dart" hide Category;
import 'package:http/http.dart' as http;

import "models.dart";

final Artist _artist = Artist(
  id: 91801,
  name: "わか、ふうり、すなお from STAR☆ANIS",
);

final Song _song = Song(
  id: 360715,
  title: "アイドル活動!",
  series: "アイカツ!",
  dateAdded: "2013/03/30",
  lyrics: "さぁ! 行こう 光る未来へ ホラ",
  hasVideo: false,
  artist: _artist,
);

class Searcher {
  Searcher({
    @required this.baseUrl = "https://clubdarn.aikats.us/api",
    this.serialNo,
  });

  String baseUrl;
  String serialNo;

  Random _rng = Random(); // TODO: Temporary solution

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
    await Future.delayed(const Duration(milliseconds: 250));

    return Page(
      artistCategoryId: "010000",
      items: List.filled(_rng.nextInt(8), _artist),
    );
  }

  Future<Page<Song>> getSongsByArtistId(int id) async {
    // TODO
    await Future.delayed(const Duration(milliseconds: 250));
    return Page(
      artistCategoryId: "010000",
      seriesCategoryId: null,
      items: List.filled(_rng.nextInt(8), _song),
    );
  }

  Future<Page<Series>> getSeriesByTitle(String title) async {
    // TODO
    await Future.delayed(const Duration(milliseconds: 250));
    return Page(
      artistCategoryId: "010000",
      seriesCategoryId: "050100",
      items: [
        Series(title: "アイカツ!"),
        Series(title: "アイカツスターズ!"),
        Series(title: "アイカツフレンズ!"),
        Series(title: "劇場版 アイカツ!"),
        Series(title: "劇場版アイカツスターズ!"),
      ],
    );
  }

  Future<Page<CategoryGroup>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 250));

    final CategoryGroup _categoryGroup = CategoryGroup(
      description: CategoryDescription(
        en: "New Songs",
        ja: "新曲",
      ),
      categories: [
        Category(
          id: "030100",
          description: CategoryDescription(
            en: "All",
            ja: "全曲",
          ),
        ),
      ],
    );

    return Page(
      artistCategoryId: "010000",
      items: List.filled(_rng.nextInt(8), _categoryGroup),
    );
  }

  Future<Page<Song>> getSongsForCategoryId(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return Page(
      artistCategoryId: "010000",
      seriesCategoryId: null,
      items: List.filled(_rng.nextInt(8), _song),
    );
  }

  Future<Page<Song>> getSongsForSeries(String seriesTitle,
      {String categoryId = "050100"}) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return Page(
      artistCategoryId: "010000",
      seriesCategoryId: "050100",
      items: List.filled(_rng.nextInt(8), _song),
    );
  }
}
