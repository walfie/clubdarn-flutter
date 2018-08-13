import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fluro/fluro.dart';

import "models.dart";
import "searcher.dart";
import "widgets/subpage.dart";
import "widgets/search_results.dart";

class Routes {
  static String songsByArtistId(int artistId, {String pageTitle = ""}) {
    return "/artists/$artistId/songs?pageTitle=${Uri.encodeQueryComponent(pageTitle)}";
  }

  static void configureRoutes(Router router, Searcher searcher) {
    final songsByArtistId = Handler(handlerFunc: (context, params) {
      final artistId = int.tryParse(params["artistId"]?.first) ?? 0;
      final title = params["pageTitle"]?.first;

      final future = searcher.getSongsByArtistId(artistId).then((songs) {
        return SongSearchResults(songs: songs);
      });

      return Subpage(title: title, child: FutureSearchResults(future: future));
    });

    router.define("/artists/:artistId/songs", handler: songsByArtistId);
  }
}
