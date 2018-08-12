import "package:flutter/material.dart";

import "models.dart";
import "widgets/search_bar.dart";
import "widgets/search_result.dart";

class ClubDarn extends StatefulWidget {
  @override
  _ClubDarnState createState() => _ClubDarnState();
}

class _ClubDarnState extends State<ClubDarn> {
  @override
  Widget build(BuildContext context) {
    final searchTab = Column(
      children: [
        SearchBar(
          onSubmitted: (SearchValues value) {
            // TODO
            debugPrint(value.query);
            debugPrint(value.searchType.toString());
          },
        ),
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SongSearchResult(
              song: Song(
                id: 360715,
                title: "アイドル活動!",
                series: "アイカツ!",
                dateAdded: "2013/03/30",
                lyrics: "さぁ! 行こう 光る未来へ ホラ",
                hasVideo: true,
                artist: Artist(
                  id: 91801,
                  name: "わか、ふうり、すなお from STAR☆ANIS",
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final tabs = [
      searchTab,
      Text("Rankings"),
      Text("Settings"),
    ].map((widget) {
      return Padding(padding: EdgeInsets.all(16.0), child: widget);
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
  runApp(ClubDarn());
}
