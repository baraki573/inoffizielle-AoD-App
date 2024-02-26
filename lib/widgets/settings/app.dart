/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/pages/popup.dart';
import 'package:unoffical_aod_app/test/moor.dart';

class AppSettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'Sitzung merken (WIP)',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Switch(
              focusNode: appSettingsFocusNodes[0],
              focusColor: Theme.of(context).accentColor,
              onChanged: (bool value) {
                setState(() {
                  settings.appSettings.setKeepSession(value);
                });
              },
              value: settings.appSettings.keepSession,
            ),
          ),
          FlatButton(
            focusColor: Theme.of(context).accentColor,
            focusNode: appSettingsFocusNodes[1],
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Logout',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
            ),
            onPressed: () async {
              await logout();
              Navigator.pushReplacementNamed(context, '/base');
            },
          ),
          FlatButton(
            focusColor: Theme.of(context).accentColor,
            focusNode: appSettingsFocusNodes[2],
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Über die App',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          FlatButton(
            focusColor: Theme.of(context).accentColor,
            focusNode: appSettingsFocusNodes[3],
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Updates',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: () {
              print('go to updates');
              Navigator.pushNamed(context, '/updates');
            },
          ),
          FlatButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => _dialog(context),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Favoriten Import/Export',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () async {
              int n = await Database().getNumber();
              if (n == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Keine Favoriten vorhanden!")));
                return;
              }
              var t = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => LoadingAlert(n),
              );

              if (t != null && t.length > 0)
                showDialog(
                  context: context,
                  builder: (context) => _deleteDialog(context, t),
                );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Favoriten Updaten',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deleteDialog(context, List<Favorite> favs) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text("Hinweis"),
      content: RichText(
        text: TextSpan(children: [
          TextSpan(
              text:
                  "Der folgende Anime wurde wahrscheinlich aus dem AOD-Katalog entfernt. "
                  "Soll auch der Favoriteneintrag gelöscht werden?\n\n"),
          TextSpan(
              text: favs.fold(
                  "", (prev, el) => "- ${el.name} (${el.type})\n$prev"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "\nDies kann nicht rückgängig gemacht werden."),
        ]),
      ),
      actions: [
        FlatButton(
          onPressed: () async {
            Navigator.pop(context);
            for (var f in favs) await Database().deleteEntry(f.id);
            setState(() {});
            //Database().deleteEntries(favs.map((e) => e.id)).then((_) => setState(() {}));
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

  Widget _dialog(context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text("Export/Import"),
      content: Text("Mit dem Export werden alle gespeicherten Daten "
          "in die Zwischenablage kopiert.\n"
          "Beim Import ist dies genau andersherum: In der Zwischenablage"
          "liegende Daten werden eingelesen und überschreiben ggf. vorhandene."),
      actions: [
        TextButton(
          child: Text(
            "Export",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await FlutterClipboard.copy(await Database().export());
            _showSnack("In Zwischenablage exportiert!");
          },
        ),
        TextButton(
          child: Text(
            "Import",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: () async {
            Navigator.pop(context);
            bool b = await Database().import(await FlutterClipboard.paste());
            _showSnack(
                b ? "Aus Zwischenablage importiert!" : "Fehler beim Import.");
          },
        ),
      ],
    );
  }

  void _showSnack(String text, {int sec = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: sec),
      ),
    );
  }
}
