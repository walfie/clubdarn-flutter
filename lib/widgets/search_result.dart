import "package:flutter/material.dart" hide Category;

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
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(14.0),
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

    final cardWithPadding = Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 65.0),
        child: card,
      ),
    );

    if (badge == null) {
      return cardWithPadding;
    } else {
      return Stack(
        overflow: Overflow.visible,
        children: [
          cardWithPadding,
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
    this.seriesCategoryId,
    this.showSeriesTitle = false,
    this.hideArtistName = false,
  }) : super(key: key);

  final Song song;
  final String seriesCategoryId;
  final bool showSeriesTitle;
  final bool hideArtistName;

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

  Widget _clickableText({BuildContext context, String text, String route}) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Text _textOrNull(String text) => text != null ? Text(text) : null;

  @override
  Widget build(BuildContext context) {
    // TODO: Add helper
    final idString = song.id.toString().replaceRange(4, 4, "-");

    final artistName = _clickableText(
      context: context,
      text: song.artist.name,
      route:
          Routes.songsByArtistId(song.artist.id, pageTitle: song.artist.name),
    );

    final seriesTitle = seriesCategoryId != null
        ? _clickableText(
            context: context,
            text: song.series,
            route: Routes.songsForSeries(
              song.series,
              categoryId: seriesCategoryId,
            ),
          )
        : _textOrNull(song.series);

    final dateAdded = song.dateAdded == "1900/01/01" ? null : song.dateAdded;

    final rows = [
      _row(Icon(Icons.music_note), _textOrNull(song.title)),
      _row(Icon(Icons.person), artistName),
      _row(Icon(Icons.local_movies), seriesTitle),
      _row(Icon(Icons.date_range), _textOrNull(dateAdded)),
      _row(Icon(Icons.sms), _textOrNull(song.lyrics)),
      _row(Icon(Icons.movie),
          song.hasVideo == true ? Text("Has music video") : null),
    ].where(_notNull).toList();

    String subtitle = null;
    if (showSeriesTitle && song.series != null) {
      subtitle = song.series;
    } else if (!hideArtistName) {
      subtitle = song.artist.name;
    }

    return SearchResult(
      id: idString,
      title: song.title,
      subtitle: subtitle,
      badge: song.hasVideo == true ? "\u{1F3AC}" : null,
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

class SeriesSearchResult extends StatelessWidget {
  const SeriesSearchResult({
    Key key,
    @required this.series,
    this.onTap,
  }) : super(key: key);

  final Series series;
  final Function(Series) onTap;

  @override
  Widget build(BuildContext context) {
    return SearchResult(
      title: series.title,
      onTap: () {
        return onTap(series);
      },
    );
  }
}

class CategorySearchResult extends StatelessWidget {
  const CategorySearchResult({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function(Category) onTap;

  @override
  Widget build(BuildContext context) {
    return SearchResult(
      title: category.description.en,
      subtitle: category.description.ja,
      onTap: () {
        return onTap(category);
      },
    );
  }
}
