import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/test/connection.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';

import 'SizeConfig.dart';
import 'consts.dart';
import 'moor.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FavoritesPageState();
}

enum Sorting { RELEASED, ALPHA, REC_ADDED, WATCHED }

class _FavoritesPageState extends State<FavoritesPage> {
  bool _showMov = true, _showSer = true;
  static Map<String, bool> _filters = {
    "abenteuer": true,
    "action": true,
    "comedy": true,
    "drama": true,
    "erotik": true,
    "fantasy": true,
    "horror": true,
    "mystery": true,
    "romance": true,
    "science fiction": true,
  };

  static Sorting _currentDropdown = Sorting.WATCHED;
  static bool _inverse = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Favoriten'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                contentPadding:
                    EdgeInsets.only(left: 16, right: 16, bottom: 19, top: 19),
                backgroundColor: Theme.of(context).canvasColor,
                title: Text("Mögliche Aktionen"),
                content: Text("Einmal tippen - Anime öffnen\n\n"
                    "Gedrückt halten - Favorit löschen\n\n"
                    "Seitlich swipen - Farbe ändern"),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarCustom(FocusNode()),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 15),
              DropdownButton(
                value: _currentDropdown,
                items: [
                  _menuItem(Sorting.WATCHED, "Angeschaut"),
                  _menuItem(Sorting.ALPHA, "Alphabetisch"),
                  _menuItem(Sorting.RELEASED, "Veröffentlicht"),
                  _menuItem(Sorting.REC_ADDED, "Hinzugefügt"),
                ],
                onChanged: (val) => setState(() => _currentDropdown = val),
              ),
              IconButton(
                icon:
                    Icon(_inverse ? Icons.arrow_upward : Icons.arrow_downward),
                color: Colors.white,
                splashRadius: 20,
                onPressed: () => setState(() => _inverse = !_inverse),
              ),
              Text("    Filme"),
              Checkbox(
                value: _showMov,
                onChanged: (b) => setState(() => _showMov = b),
                activeColor: Theme.of(context).accentColor,
              ),
              Text("Serien"),
              Checkbox(
                value: _showSer,
                onChanged: (b) => setState(() => _showSer = b),
                activeColor: Theme.of(context).accentColor,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            alignment: Alignment.center,
            height: 35,
            child: Scrollbar(
              thickness: 1.5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                      Center(
                          child: Text(
                        "Genre Filter:    ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                    ] +
                    _filters.entries.map(_genreClick).toList(),
              ),
            ),
          ),
          _favorites(),
        ],
      ),
    );
  }

  Widget _genreCheckbox(MapEntry<String, bool> e) {
    var name = e.key;
    var clicked = e.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name.toUpperCase()),
        Checkbox(
          value: clicked,
          onChanged: (b) => setState(() => _filters[name] = !clicked),
          activeColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }

  Widget _genreClick(MapEntry<String, bool> e) {
    var name = e.key;
    var clicked = e.value;
    return Padding(
      padding: EdgeInsets.only(right: 7),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: clicked
              ? MaterialStateProperty.all(Theme.of(context).accentColor)
              : MaterialStateProperty.all(Colors.transparent),
          overlayColor: clicked
              ? MaterialStateProperty.all(Colors.black38)
              : MaterialStateProperty.all(Colors.white30),
        ),
        onPressed: () => setState(() => _filters[name] = !clicked),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _favorites() {
    return FutureBuilder(
      future: Database().getEntries(),
      builder: (context, snap) {
        if (snap.hasError) return Text(snap.error.toString());
        if (!snap.hasData) return Center(child: Text("Keine Favoriten"));

        // the data
        List<Favorite> data = snap.data;

        // filter
        if (!_showMov) data = data.where((f) => f.type != "Film").toList();
        if (!_showSer) data = data.where((f) => f.type != "Serie").toList();

        _filters.forEach((key, value) {
          if (!value)
            data.removeWhere((e) => e.genre.toLowerCase().contains(key));
        });

        // sort the entries
        switch (_currentDropdown) {
          case Sorting.RELEASED:
            data.sort((a, b) => a.prodYear.compareTo(b.prodYear));
            break;
          case Sorting.ALPHA:
            data.sort((a, b) => a.name.compareTo(b.name));
            break;
          case Sorting.REC_ADDED:
            data.sort((a, b) => a.addDate.compareTo(b.addDate));
            break;
          case Sorting.WATCHED:
            data.sort((a, b) {
              int i = b.watchDate.compareTo(a.watchDate);
              if (i == 0) return a.addDate.compareTo(b.addDate);
              return i;
            });
            break;
          default:
        }

        if (_inverse) data = data.reversed.toList();

        return Expanded(
          child: data.isNotEmpty
              ? SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: data.map((f) => _singleRect(f)).toList(),
                  ),
                )
              : Center(child: Text("\n\nKeine Favoriten")),
        );
      },
    );
  }

  DropdownMenuItem _menuItem(Sorting s, String t) {
    return DropdownMenuItem(
      value: s,
      child: Text(t, style: Theme.of(context).textTheme.bodyText2),
    );
  }

  Color _getColor(num) {
    switch (num) {
      case 1:
        return Theme.of(context).accentColor.withOpacity(.5);
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.white;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.deepPurple;
      default:
        return Theme.of(context).accentColor;
    }
  }

  Map<String, FocusNode> map = {};

  Widget _singleRect(Favorite fav) {
    map.putIfAbsent(fav.name, () => FocusNode());
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: GestureDetector(
      onHorizontalDragEnd: (details) {
        int dir = details.primaryVelocity.sign.toInt();
        var newVal = (fav.marked + dir + MAX_MARKED) % MAX_MARKED;
        Database().setMarked(fav.id, newVal).then((_) => setState(() {}));
      },
      child: FlatButton(
        padding: EdgeInsets.zero,
        color: _getColor(fav.marked),
        focusColor: Colors.blueGrey,
        onPressed: () async {
          /*if ((await getData("https://anime-on-demand.de/anime/${fav.id}")) ==
              null) {
            showDialog(
              context: context,
              builder: (context) => _deleteDialog(context, fav, avail: false),
            );
            return;
          }*/
          Database().setWatched(fav.id).then((_) => setState(() {}));
          var t = await Navigator.pushNamed(
            context,
            '/anime',
            arguments: Anime(
              name: fav.name,
              imageUrl: fav.image,
              id: fav.id,
              year: fav.prodYear,
              fsk: fav.fsk,
              genre: fav.genre,
            ),
          );
          if (t == false)
            showDialog(
              context: context,
              builder: (context) => _deleteDialog(context, fav, avail: false),
            );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => _deleteDialog(context, fav),
          );
        },
        child: Container(
          width: horSize(45, 30.8),
          height: horSize(35, 24),
          decoration: BoxDecoration(
              /*boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0)
            ],*/
              //color: _getColor(fav.marked),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name
              Container(
                height: 33,
                alignment: Alignment.center,
                child: Text(
                  fav.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              // Image
              Expanded(
                child: CachedNetworkImage(
                  placeholder: (context, s) => Container(
                    color: Colors.grey[700],
                    alignment: Alignment.center,
                    child: Icon(Icons.image),
                  ),
                  imageUrl: fav.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),),
    );
    /*return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: GestureDetector(
        onTap: () async {
          /*if ((await getData("https://anime-on-demand.de/anime/${fav.id}")) ==
              null) {
            showDialog(
              context: context,
              builder: (context) => _deleteDialog(context, fav, avail: false),
            );
            return;
          }*/
          Database().setWatched(fav.id).then((_) => setState(() {}));
          var t = await Navigator.pushNamed(
            context,
            '/anime',
            arguments: Anime(
              name: fav.name,
              imageUrl: fav.image,
              id: fav.id,
              year: fav.prodYear,
              fsk: fav.fsk,
              genre: fav.genre,
            ),
          );
          if (t == false)
            showDialog(
              context: context,
              builder: (context) => _deleteDialog(context, fav, avail: false),
            );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => _deleteDialog(context, fav),
          );
        },
        onHorizontalDragEnd: (details) {
          int dir = details.primaryVelocity.sign.toInt();
          var newVal = (fav.marked + dir + MAX_MARKED) % MAX_MARKED;
          Database().setMarked(fav.id, newVal).then((_) => setState(() {}));
        },
        child: Container(
          width: horSize(45, 30.8),
          height: horSize(35, 24),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0)
            ],
            color: _getColor(fav.marked),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name
              Container(
                height: 33,
                alignment: Alignment.center,
                child: Text(
                  fav.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              // Image
              Expanded(
                child: CachedNetworkImage(
                  placeholder: (context, s) => Container(
                    color: Colors.grey[700],
                    alignment: Alignment.center,
                    child: Icon(Icons.image),
                  ),
                  imageUrl: fav.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );*/
  }

  Widget _deleteDialog(context, fav, {avail = true}) {
    var text = avail
        ? "Soll der folgender Anime wirklich aus den Favoriten entfernt werden?\n\n"
        : "Der folgende Anime wurde wahrscheinlich aus dem AOD-Katalog entfernt. "
            "Soll auch der Favoriteneintrag gelöscht werden?\n\n";
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text("Hinweis"),
      content: RichText(
        text: TextSpan(children: [
          TextSpan(text: text),
          TextSpan(
              text: "${fav.name}\n\n",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "Dies kann nicht rückgängig gemacht werden."),
        ]),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Database().deleteEntry(fav.id).then((_) => setState(() {}));
          },
          child: Text(
            "Entfernen",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Schließen",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ],
    );
  }
}
