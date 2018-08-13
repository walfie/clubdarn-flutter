import 'dart:async';
import 'dart:math'; // TODO: Remove when Random is not needed

import 'package:flutter/foundation.dart';

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
    @required this.baseUrl = "https://clubdarn.aikats.us",
    this.serialNo,
  });

  String baseUrl;
  String serialNo;

  Random _rng = Random(); // TODO: Temporary solution

  Future<Page<Song>> getSongsByTitle(String title) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return Page(
      artistCategoryId: "010000",
      items: List.filled(_rng.nextInt(8) + 1, _song),
    );
  }

  Future<Page<Artist>> getArtistsByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return Page(
      artistCategoryId: "010000",
      items: List.filled(_rng.nextInt(8) + 1, _artist),
    );
  }

  Future<Page<Song>> getSongsByArtistId(int id) async {
    // TODO
    await Future.delayed(const Duration(milliseconds: 250));
    return Page(
      artistCategoryId: "010000",
      seriesCategoryId: "050100",
      items: List.filled(_rng.nextInt(8) + 1, _song),
    );
  }
}
