import "package:flutter/material.dart";

import "search_result.dart";
import "../models.dart";

abstract class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key key,
  }) : super(key: key);
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
        child: ArtistSearchResult(artist: artist),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}
