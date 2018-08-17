import 'dart:async';
import 'dart:collection';

import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Category;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import "search_result.dart";
import "../routes.dart";
import "../models.dart";

abstract class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key key,
  }) : super(key: key);

  bool isEmpty();
}

class FutureSearchResults extends SearchResultsWidget {
  const FutureSearchResults({
    Key key,
    @required this.future,
  }) : super(key: key);

  final Future<SearchResultsWidget> future;

  bool isEmpty() => null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else if (snapshot.data.isEmpty()) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.grey,
                      size: 40.0,
                    ),
                  ),
                  Center(child: Text("No results")),
                ],
              );
            } else {
              return snapshot.data;
            }
        }
      },
    );
  }
}

class SongSearchResults extends SearchResultsWidget {
  const SongSearchResults({
    Key key,
    this.showSeriesTitle = false,
    this.hideArtistName = false,
    @required this.songs,
  }) : super(key: key);

  final bool showSeriesTitle;
  final bool hideArtistName;
  final Page<Song> songs;

  bool isEmpty() => songs.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    List<Widget> items;
    VerticalDirection verticalDirection = VerticalDirection.down;
    final seriesCategoryId = songs.seriesCategoryId;

    items = songs.items.map((song) {
      return SongSearchResult(
        song: song,
        showSeriesTitle: showSeriesTitle,
        seriesCategoryId: seriesCategoryId,
        hideArtistName: hideArtistName,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalDirection: verticalDirection,
      children: items,
    );
  }
}

class FullscreenSongSearchResults extends SearchResultsWidget {
  const FullscreenSongSearchResults({
    Key key,
    this.groupByDate = false,
    this.showSeriesTitle = false,
    this.hideArtistName = false,
    @required this.songs,
  }) : super(key: key);

  final bool groupByDate;
  final bool showSeriesTitle;
  final bool hideArtistName;
  final Page<Song> songs;
  final _scrollController = ScrollController();

  bool isEmpty() => songs.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.0),
      itemCount: songs.items.length,
      itemBuilder: (context, index) {
        if (index >= songs.items.length) {
          return null;
        }

        final song = songs.items[index];
        final songWidget = SongSearchResult(
          song: song,
          showSeriesTitle: showSeriesTitle,
          seriesCategoryId: songs.seriesCategoryId,
          hideArtistName: hideArtistName,
        );

        if (groupByDate) {
          final showDate = index == 0 ||
              (songs.items[index - 1]?.dateAdded != song.dateAdded);

          if (showDate) {
            final date =
                song.dateAdded == "1900/01/01" ? "Unknown" : song.dateAdded;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    date,
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
                songWidget,
              ],
            );
          }
        }

        return songWidget;
      },
    );

    return DraggableScrollbar.semicircle(
      controller: _scrollController,
      child: listView,
    );
  }
}

class ArtistSearchResults extends SearchResultsWidget {
  const ArtistSearchResults({
    Key key,
    @required this.artists,
  }) : super(key: key);

  final Page<Artist> artists;

  bool isEmpty() => artists.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    final onTap = (artist) {
      Navigator.pushNamed(
        context,
        Routes.songsByArtistId(artist.id, pageTitle: artist.name),
      );
    };

    final items = artists.items.map((artist) {
      return ArtistSearchResult(
        artist: artist,
        onTap: onTap,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}

class SeriesSearchResults extends SearchResultsWidget {
  const SeriesSearchResults({
    Key key,
    @required this.series,
    @required this.seriesCategoryId = "050100", // TODO: Stop hardcoding this
  }) : super(key: key);

  final String seriesCategoryId;
  final Page<Series> series;

  bool isEmpty() => series.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    final onTap = (series) {
      Navigator.pushNamed(
        context,
        Routes.songsForSeries(series.title, categoryId: this.seriesCategoryId),
      );
    };

    final items = series.items.map((series) {
      return SeriesSearchResult(
        series: series,
        onTap: onTap,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}

class CategorySearchResults extends SearchResultsWidget {
  const CategorySearchResults({
    Key key,
    this.title,
    @required this.categoryGroups,
  }) : super(key: key);

  final String title;
  final Page<CategoryGroup> categoryGroups;

  bool isEmpty() => categoryGroups.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    final onTap = (category) {
      Navigator.pushNamed(
        context,
        Routes.songsForCategoryId(
          category.id,
          pageTitle: category.description.en,
        ),
      );
    };

    final items = categoryGroups.items.map((categoryGroup) {
      final categories = categoryGroup.categories.map((category) {
        return CategorySearchResult(
          category: category,
          onTap: onTap,
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryGroup.description.en,
            style: const TextStyle(fontSize: 25.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(children: categories),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}
