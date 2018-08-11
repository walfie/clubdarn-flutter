import 'package:flutter/material.dart';

class ClubDarn extends StatefulWidget {
  @override
  _ClubDarnState createState() => _ClubDarnState();
}

class _ClubDarnState extends State<ClubDarn> {
  @override
  Widget build(BuildContext context) {
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
          body: TabBarView(
            children: [
              SearchBar(),
              Text("Rankings"),
              Text("Settings"),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

enum SearchType { song, artist, series }

class _SearchBarState extends State<SearchBar> {
  SearchType _searchType = SearchType.song;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // TODO
                  },
                ),
              ),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: RadioListTile<SearchType>(
                  title: Text("Song"),
                  value: SearchType.song,
                  groupValue: _searchType,
                  onChanged: (SearchType value) {
                    setState(() {
                      _searchType = value;
                    });
                  },
                ),
              ),
              Flexible(
                child: RadioListTile<SearchType>(
                  title: Text("Artist"),
                  value: SearchType.artist,
                  groupValue: _searchType,
                  onChanged: (SearchType value) {
                    setState(() {
                      _searchType = value;
                    });
                  },
                ),
              ),
              Flexible(
                child: RadioListTile<SearchType>(
                  title: Text("Series"),
                  value: SearchType.series,
                  groupValue: _searchType,
                  onChanged: (SearchType value) {
                    setState(() {
                      _searchType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(ClubDarn());
}
