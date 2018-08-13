import 'dart:async';

import "package:flutter/material.dart";

import "models.dart";
import "searcher.dart";
import "widgets/search_bar.dart";
import "widgets/search_result.dart";
import "widgets/search_results.dart";

class ClubDarn extends StatefulWidget {
  ClubDarn({
    @required this.searcher,
  });

  final Searcher searcher;

  @override
  _ClubDarnState createState() => _ClubDarnState();
}

class _ClubDarnState extends State<ClubDarn> {
  Future<SearchResultsWidget> _searchResultsView = null;

  Future<SearchResultsWidget> _executeSearch(SearchValues value) {
    switch (value.searchType) {
      case SearchType.song:
        return widget.searcher.getSongsByTitle(value.query).then((songs) {
          return SongSearchResults(songs: songs);
        });

      case SearchType.artist:
        return widget.searcher.getArtistsByName(value.query).then((artists) {
          return ArtistSearchResults(artists: artists);
        });

      default:
        // TODO
        return widget.searcher.getArtistsByName(value.query).then((results) {
          return ArtistSearchResults(artists: results);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchTab = Column(
      children: [
        SearchBar(
          onSubmitted: (SearchValues value) {
            setState(() {
              _searchResultsView = _executeSearch(value);
            });
          },
        ),
        Divider(),
        FutureSearchResults(future: _searchResultsView),
      ],
    );

    final tabs = [
      searchTab,
      Text("Rankings"),
      Text("Settings"),
    ].map((widget) {
      return SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(16.0), child: widget),
      );
    }).toList(growable: false);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.search)),
                    Tab(icon: Icon(Icons.format_list_numbered)),
                    Tab(icon: Icon(Icons.settings)),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(children: tabs),
        ),
      ),
    );
  }
}

void main() {
  Searcher searcher = Searcher();
  runApp(ClubDarn(searcher: searcher));
}
