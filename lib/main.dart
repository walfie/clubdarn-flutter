import "package:flutter/material.dart";

import "models.dart";
import "widgets/search_bar.dart";

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
              SearchBar(
                onSubmitted: (SearchValues value) {
                  // TODO
                  debugPrint(value.query);
                  debugPrint(value.searchType.toString());
                },
              ),
              Text("Rankings"),
              Text("Settings"),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(ClubDarn());
}
