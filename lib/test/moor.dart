import 'dart:convert';
import 'dart:io';


import 'package:intl/intl.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'connection.dart';
import 'consts.dart';

part 'moor.g.dart';

class Favorites extends Table {
  IntColumn get id => integer()();

  TextColumn get image => text()();

  TextColumn get name => text()();

  TextColumn get type => text()();

  IntColumn get currentEp => integer()();

  TextColumn get genre => text()();

  TextColumn get epNum => text()();

  IntColumn get fsk => integer()();

  IntColumn get prodYear => integer()();

  TextColumn get addDate => text().map(DateConverter())();

  TextColumn get watchDate => text()
      .map(DateConverter())
      .withDefault(Constant("01.01.1995 10:00:00"))();

  IntColumn get marked => integer().withDefault(Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class DateConverter extends TypeConverter<DateTime, String> {
  static DateFormat format = DateFormat("dd.MM.yyyy HH:mm:ss");

  @override
  DateTime mapToDart(String fromDb) {
    if (fromDb.length < 17) fromDb += ":00";
    return format.parse(fromDb);
  }

  @override
  String mapToSql(DateTime value) {
    return format.format(value);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbfolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbfolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Favorites])
class Database extends _$Database {
  static Database _db;

  Database._intern() : super(_openConnection());

  factory Database() {
    if (_db == null) _db = Database._intern();
    return _db;
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) => m.createAll(),
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2 && to >= 2) {
          m.alterTable(TableMigration(
            favorites,
            columnTransformer: {
              favorites.epNum: favorites.epNum.cast<String>()
            },
          ));
        }
        if (from < 3 && to >= 3) {
          m.addColumn(favorites, favorites.marked);
        }
        if (from < 4 && to >= 4) {
          m.addColumn(favorites, favorites.watchDate);
          m.alterTable(TableMigration(
            favorites,
            columnTransformer: {favorites.marked: favorites.marked.cast<int>()},
          ));
        }
      });

  Future putEntry(id,
      {name,
      image,
      type = "Serie",
      currentEp = 1,
      genre = "",
      prodYear = 2020,
      fsk = 6,
      epNum = 12}) {
    return into(favorites).insert(
        FavoritesCompanion.insert(
          id: Value(id),
          image: image,
          name: name,
          type: type,
          currentEp: currentEp,
          genre: genre,
          prodYear: prodYear,
          addDate: DateTime.now(),
          watchDate: Value(DateTime.now()),
          fsk: fsk,
          epNum: epNum,
        ),
        mode: InsertMode.insertOrReplace);
  }

  Future setMarked(id, marked) {
    return (update(favorites)..where((t) => t.id.equals(id)))
        .write(FavoritesCompanion(marked: Value(marked)));
  }

  Future setWatched(id) {
    return (update(favorites)..where((t) => t.id.equals(id)))
        .write(FavoritesCompanion(watchDate: Value(DateTime.now())));
  }

  Future deleteEntry(int id) {
    return (delete(favorites)..where((t) => t.id.equals(id))).go();
  }

  Future deleteEntries(List<int> ids) {
    return (delete(favorites)..where((t) => t.id.isIn(ids))).go();
  }

  Future<List<Favorite>> getEntries() {
    return select(favorites).get();
  }

  Future<bool> isFav(id) async {
    var q =
        (select(favorites)..where((f) => f.id.equals(id))).getSingleOrNull();
    return Future.value(await q != null);
  }

  Future<String> export() async {
    var q = (await select(favorites).get())
        .map((f) => {
              "id": f.id,
              "name": f.name,
              "image": f.image,
              "type": f.type,
              "genre": f.genre,
              "watchDate": DateConverter.format.format(f.watchDate),
              "addDate": DateConverter.format.format(f.addDate),
              "prodYear": f.prodYear,
              "currentEp": f.currentEp,
              "epNum": f.epNum,
              "fsk": f.fsk,
              "marked": f.marked,
            })
        .toList();
    var exp = jsonEncode(q);
    return exp;
  }

  Future<bool> import(String s) async {
    try {
      List data = jsonDecode(s);
      List<FavoritesCompanion> toInsert = data
          .map((e) => FavoritesCompanion.insert(
                id: Value(e["id"]),
                image: e["image"],
                name: e["name"],
                type: e["type"],
                currentEp: e.containsKey("currentEp") ? e["currentEp"] : 0,
                genre: e["genre"],
                epNum: e["epNum"],
                fsk: e["fsk"],
                marked: Value(e.containsKey("marked") && e["marked"] is int
                    ? e["marked"]
                    : 0),
                watchDate: e.containsKey("watchDate")
                    ? Value(DateConverter.format.parse(e["watchDate"]))
                    : Value.absent(),
                prodYear: e["prodYear"],
                addDate: DateConverter.format.parse(e["addDate"]),
              ))
          .toList();
      await batch((batch) => batch.insertAll(favorites, toInsert,
          mode: InsertMode.insertOrReplace));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<int> getNumber() {
    return select(favorites).get().then((value) => value.length);
  }

  Future<List<Favorite>> updateData({Function updateFunc}) async {
    List<Favorite> data = await select(favorites).get();
    if (data.isEmpty) return [];
    List<Favorite> toRemove = [];
    for (int i = 0; i < data.length; i++) {
      print("${i+1}/${data.length}");
      Favorite f = data[i];

      var d = await getData(HOME_PAGE + "anime/${f.id}");
      if (d == null) {
        print("Not Found [${f.id}]: ${f.name}, ${f.type}");
        toRemove.add(f);
        continue;
      }
      data[i] = f.copyWith(
        name: d["title"],
        image: d["image"],
        genre: d["genre"],
        type: d["type"],
        fsk: d["fsk"],
        epNum: d["episodes"],
      );
      if (updateFunc != null) updateFunc();
    }
    print("Finish!");
    data.removeWhere((f) => toRemove.contains(f));
    //delete(favorites);
    await batch((batch) =>
        batch.insertAll(favorites, data, mode: InsertMode.insertOrReplace));
    return toRemove;
  }
}
