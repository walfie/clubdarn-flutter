import "dart:async";

import "package:flutter/foundation.dart";
import "package:fluro/fluro.dart";

import "models.dart";
import "searcher.dart";
import "widgets/subpage.dart";
import "widgets/search_results.dart";

class Routes {
  static String songsByArtistId(int artistId, {String pageTitle = ""}) {
    return "/artists/$artistId/songs?pageTitle=${Uri.encodeQueryComponent(pageTitle)}";
  }

  static String songsForCategoryId(String categoryId, {String pageTitle = ""}) {
    return "/categories/$categoryId/songs?pageTitle=${Uri.encodeQueryComponent(pageTitle)}";
  }

  static String songsForSeries(String seriesTitle,
      {String categoryId = "050100"}) {
    return "/categories/$categoryId/series/${Uri.encodeComponent(seriesTitle)}";
  }

  static void configureRoutes(Router router, Searcher searcher) {
    final songsByArtistId = Handler(handlerFunc: (context, params) {
      final artistId = int.tryParse(params["artistId"]?.first) ?? 0;
      final title = params["pageTitle"]?.first;

      final future = searcher.getSongsByArtistId(artistId).then((songs) {
        return SongSearchResults(songs: songs, hideArtistName: true);
      });

      return Subpage(title: title, child: FutureSearchResults(future: future));
    });

    router.define("/artists/:artistId/songs", handler: songsByArtistId);

    final songsForCategoryId = Handler(handlerFunc: (context, params) {
      final categoryId = params["categoryId"]?.first;
      final title = params["pageTitle"]?.first;

      final future = searcher.getSongsForCategoryId(categoryId).then((songs) {
        return SongSearchResults(
          songs: songs,
          groupByDate: true,
          showSeriesTitle: true,
        );
      });

      return Subpage(title: title, child: FutureSearchResults(future: future));
    });

    router.define("/categories/:categoryId/songs", handler: songsForCategoryId);

    final songsForSeries = Handler(handlerFunc: (context, params) {
      final categoryId = params["categoryId"]?.first;
      final seriesTitle = Uri.decodeComponent(params["seriesTitle"]?.first);

      final future = searcher
          .getSongsForSeries(seriesTitle, categoryId: categoryId)
          .then((songs) => SongSearchResults(songs: songs));

      return Subpage(
        title: seriesTitle,
        child: FutureSearchResults(future: future),
      );
    });

    router.define("/categories/:categoryId/series/:seriesTitle",
        handler: songsForSeries);
  }
}
