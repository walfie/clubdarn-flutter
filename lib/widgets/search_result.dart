import "package:flutter/material.dart";

import "../models.dart";

class SearchResult extends StatelessWidget {
  const SearchResult({
    Key key,
    @required this.title,
    this.subtitle,
    this.id,
    this.onTap,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final String subtitle;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Text(id),
                ],
              ),
              Text(subtitle, textAlign: TextAlign.right),
            ],
          ),
        ),
      ),
    );
  }
}

class SongSearchResult extends StatelessWidget {
  const SongSearchResult({
    Key key,
    @required this.song,
  }) : super(key: key);

  final Song song;

  Widget _row(Icon icon, String text) {
    if (text == null) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: icon,
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add helper
    final idString = song.id.toString().replaceRange(4, 4, "-");

    final rows = [
      _row(Icon(Icons.music_note), song.title),
      _row(Icon(Icons.person), song.artist.name), // TODO: Clickable
      _row(Icon(Icons.local_movies), song.series),
      _row(Icon(Icons.date_range), song.dateAdded),
      _row(Icon(Icons.sms), song.lyrics),
      _row(Icon(Icons.movie), song.hasVideo == true ? "Has music video" : null),
    ].where((o) => o != null).toList();

    return SearchResult(
      id: idString,
      title: song.title,
      subtitle: song.artist.name,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(idString),
              contentPadding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0.0),
              content: SingleChildScrollView(
                child: Column(children: rows),
              ),
              actions: [
                FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
