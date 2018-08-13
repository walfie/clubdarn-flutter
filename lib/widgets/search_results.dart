import 'dart:async';

import "package:flutter/material.dart";

import "search_result.dart";
import "subpage.dart"; // TODO: Remove
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
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    final items = songs.map((song) {
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
  final List<Artist> artists;

  @override
  Widget build(BuildContext context) {
    final items = artists.map((artist) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ArtistSearchResult(
          artist: artist,
          onTap: (artist) {
            // TODO: Use named route
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Subpage(
                      title: artist.name,
                      child: Text(artist.name),
                    ),
              ),
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
