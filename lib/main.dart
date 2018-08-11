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

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key key,
    this.onSubmitted,
  }) : super(key: key);

  final ValueChanged<SearchValues> onSubmitted;

  @override
  _SearchBarState createState() => _SearchBarState();
}

enum SearchType { song, artist, series }

class SearchValues {
  String query = "";
  SearchType searchType = SearchType.song;
}

class RadioOption<T> extends StatelessWidget {
  const RadioOption({
    Key key,
    this.title,
    this.selected = false,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
  })  : assert(selected != null),
        super(key: key);

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Widget title;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onChanged != null
          ? () {
              onChanged(value);
            }
          : null,
      child: Row(
        children: [
          Radio(
            key: key,
            onChanged: onChanged,
            groupValue: groupValue,
            value: value,
          ),
          Flexible(child: title),
        ],
      ),
    );
  }
}

class _SearchBarState extends State<SearchBar> {
  SearchValues _state = SearchValues();

  Widget _radioOption(String title, SearchType searchType) {
    return Flexible(
      child: RadioOption<SearchType>(
        title: Text(title),
        value: searchType,
        groupValue: _state.searchType,
        onChanged: (SearchType value) {
          setState(() {
            _state.searchType = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String text) {
                setState(() {
                  _state.query = text;
                });
              },
              onSubmitted: (_) {
                widget.onSubmitted(_state);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                isDense: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    widget.onSubmitted(_state);
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _radioOption("Song", SearchType.song),
                _radioOption("Artist", SearchType.artist),
                _radioOption("Series", SearchType.series),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(ClubDarn());
}
