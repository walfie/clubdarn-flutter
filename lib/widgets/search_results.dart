import 'dart:async';

import "package:flutter/material.dart" hide Category;

import "search_result.dart";
import "../routes.dart";
import "../models.dart";

abstract class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key key,
  }) : super(key: key);
}

class FutureSearchResults extends SearchResultsWidget {
  const FutureSearchResults({
    Key key,
    @required this.future,
  }) : super(key: key);

  final Future<SearchResultsWidget> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("");
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return snapshot.data;
        }
      },
    );
  }
}

class SongSearchResults extends SearchResultsWidget {
  const SongSearchResults({
    Key key,
    this.title,
    @required this.songs,
  }) : super(key: key);

  final String title;
  final Page<Song> songs;

  @override
  Widget build(BuildContext context) {
    final items = songs.items.map((song) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: SongSearchResult(song: song),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}

class ArtistSearchResults extends SearchResultsWidget {
  const ArtistSearchResults({
    Key key,
    this.title,
    @required this.artists,
  }) : super(key: key);

  final String title;
  final Page<Artist> artists;

  @override
  Widget build(BuildContext context) {
    final items = artists.items.map((artist) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ArtistSearchResult(
          artist: artist,
          onTap: (artist) {
            Navigator.pushNamed(
              context,
              Routes.songsByArtistId(artist.id, pageTitle: artist.name),
            );
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    final items = categoryGroups.items.map((categoryGroup) {
      final categories = categoryGroup.categories.map((category) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: CategorySearchResult(
            category: category,
            onTap: (category) {
              // TODO
            },
          ),
        );
      }).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryGroup.description.en,
            style: const TextStyle(fontSize: 20.0),
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
