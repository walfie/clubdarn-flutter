import "package:flutter/material.dart";

import "../models.dart";
import "../routes.dart";

bool _notNull(Object o) => o != null;

class SearchResult extends StatelessWidget {
  const SearchResult({
    Key key,
    this.id,
    @required this.title,
    this.subtitle,
    this.badge,
    this.onTap,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final String subtitle;
  final String id;
  final String badge;

  @override
  Widget build(BuildContext context) {
    final card = Card(
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
                  id != null ? Text(id) : null,
                ].where(_notNull).toList(),
              ),
              subtitle != null
                  ? Text(subtitle, textAlign: TextAlign.right)
                  : null,
            ].where(_notNull).toList(),
          ),
        ),
      ),
    );

    if (badge == null) {
      return card;
    } else {
      return Stack(
        overflow: Overflow.visible,
        children: [
          card,
          Positioned(
            right: -6.0,
            top: -6.0,
            child: CircleAvatar(
              child: Text(badge, style: const TextStyle(fontSize: 14.0)),
              backgroundColor: Theme.of(context).primaryColorLight,
              radius: 15.0,
            ),
          ),
        ],
      );
    }
  }
}

class SongSearchResult extends StatelessWidget {
  const SongSearchResult({
    Key key,
    @required this.song,
  }) : super(key: key);

  final Song song;

  Widget _row(Icon icon, Widget content) {
    if (content == null) {
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
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add helper
    final idString = song.id.toString().replaceRange(4, 4, "-");

    final artistName = GestureDetector(
      child: Text(
        song.artist.name,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.songsByArtistId(song.artist.id, pageTitle: song.artist.name),
        );
      },
    );

    final rows = [
      _row(Icon(Icons.music_note), Text(song.title)),
      _row(Icon(Icons.person), artistName),
      _row(Icon(Icons.local_movies), Text(song.series)),
      _row(Icon(Icons.date_range), Text(song.dateAdded)),
      _row(Icon(Icons.sms), Text(song.lyrics)),
      _row(Icon(Icons.movie),
          song.hasVideo == true ? Text("Has music video") : null),
    ].where(_notNull).toList();

    return SearchResult(
      id: idString,
      title: song.title,
      subtitle: song.artist.name,
      badge: song.hasVideo ? "\u{1F3AC}" : null,
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

class ArtistSearchResult extends StatelessWidget {
  const ArtistSearchResult({
    Key key,
    @required this.artist,
    this.onTap,
  }) : super(key: key);

  final Artist artist;
  final Function(Artist) onTap;

  @override
  Widget build(BuildContext context) {
    return SearchResult(
      title: artist.name,
      onTap: () {
        return onTap(artist);
      },
    );
  }
}
