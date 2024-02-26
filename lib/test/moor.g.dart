// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String image;
  final String name;
  final String type;
  final int currentEp;
  final String genre;
  final String epNum;
  final int fsk;
  final int prodYear;
  final DateTime addDate;
  final DateTime watchDate;
  final int marked;
  Favorite(
      {@required this.id,
      @required this.image,
      @required this.name,
      @required this.type,
      @required this.currentEp,
      @required this.genre,
      @required this.epNum,
      @required this.fsk,
      @required this.prodYear,
      @required this.addDate,
      @required this.watchDate,
      @required this.marked});
  factory Favorite.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Favorite(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      image: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      type: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type']),
      currentEp: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}current_ep']),
      genre: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}genre']),
      epNum: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ep_num']),
      fsk: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}fsk']),
      prodYear: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}prod_year']),
      addDate: $FavoritesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}add_date'])),
      watchDate: $FavoritesTable.$converter1.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}watch_date'])),
      marked: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}marked']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || currentEp != null) {
      map['current_ep'] = Variable<int>(currentEp);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || epNum != null) {
      map['ep_num'] = Variable<String>(epNum);
    }
    if (!nullToAbsent || fsk != null) {
      map['fsk'] = Variable<int>(fsk);
    }
    if (!nullToAbsent || prodYear != null) {
      map['prod_year'] = Variable<int>(prodYear);
    }
    if (!nullToAbsent || addDate != null) {
      final converter = $FavoritesTable.$converter0;
      map['add_date'] = Variable<String>(converter.mapToSql(addDate));
    }
    if (!nullToAbsent || watchDate != null) {
      final converter = $FavoritesTable.$converter1;
      map['watch_date'] = Variable<String>(converter.mapToSql(watchDate));
    }
    if (!nullToAbsent || marked != null) {
      map['marked'] = Variable<int>(marked);
    }
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      currentEp: currentEp == null && nullToAbsent
          ? const Value.absent()
          : Value(currentEp),
      genre:
          genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      epNum:
          epNum == null && nullToAbsent ? const Value.absent() : Value(epNum),
      fsk: fsk == null && nullToAbsent ? const Value.absent() : Value(fsk),
      prodYear: prodYear == null && nullToAbsent
          ? const Value.absent()
          : Value(prodYear),
      addDate: addDate == null && nullToAbsent
          ? const Value.absent()
          : Value(addDate),
      watchDate: watchDate == null && nullToAbsent
          ? const Value.absent()
          : Value(watchDate),
      marked:
          marked == null && nullToAbsent ? const Value.absent() : Value(marked),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      image: serializer.fromJson<String>(json['image']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      currentEp: serializer.fromJson<int>(json['currentEp']),
      genre: serializer.fromJson<String>(json['genre']),
      epNum: serializer.fromJson<String>(json['epNum']),
      fsk: serializer.fromJson<int>(json['fsk']),
      prodYear: serializer.fromJson<int>(json['prodYear']),
      addDate: serializer.fromJson<DateTime>(json['addDate']),
      watchDate: serializer.fromJson<DateTime>(json['watchDate']),
      marked: serializer.fromJson<int>(json['marked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'image': serializer.toJson<String>(image),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'currentEp': serializer.toJson<int>(currentEp),
      'genre': serializer.toJson<String>(genre),
      'epNum': serializer.toJson<String>(epNum),
      'fsk': serializer.toJson<int>(fsk),
      'prodYear': serializer.toJson<int>(prodYear),
      'addDate': serializer.toJson<DateTime>(addDate),
      'watchDate': serializer.toJson<DateTime>(watchDate),
      'marked': serializer.toJson<int>(marked),
    };
  }

  Favorite copyWith(
          {int id,
          String image,
          String name,
          String type,
          int currentEp,
          String genre,
          String epNum,
          int fsk,
          int prodYear,
          DateTime addDate,
          DateTime watchDate,
          int marked}) =>
      Favorite(
        id: id ?? this.id,
        image: image ?? this.image,
        name: name ?? this.name,
        type: type ?? this.type,
        currentEp: currentEp ?? this.currentEp,
        genre: genre ?? this.genre,
        epNum: epNum ?? this.epNum,
        fsk: fsk ?? this.fsk,
        prodYear: prodYear ?? this.prodYear,
        addDate: addDate ?? this.addDate,
        watchDate: watchDate ?? this.watchDate,
        marked: marked ?? this.marked,
      );
  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currentEp: $currentEp, ')
          ..write('genre: $genre, ')
          ..write('epNum: $epNum, ')
          ..write('fsk: $fsk, ')
          ..write('prodYear: $prodYear, ')
          ..write('addDate: $addDate, ')
          ..write('watchDate: $watchDate, ')
          ..write('marked: $marked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          image.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      currentEp.hashCode,
                      $mrjc(
                          genre.hashCode,
                          $mrjc(
                              epNum.hashCode,
                              $mrjc(
                                  fsk.hashCode,
                                  $mrjc(
                                      prodYear.hashCode,
                                      $mrjc(
                                          addDate.hashCode,
                                          $mrjc(watchDate.hashCode,
                                              marked.hashCode))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.image == this.image &&
          other.name == this.name &&
          other.type == this.type &&
          other.currentEp == this.currentEp &&
          other.genre == this.genre &&
          other.epNum == this.epNum &&
          other.fsk == this.fsk &&
          other.prodYear == this.prodYear &&
          other.addDate == this.addDate &&
          other.watchDate == this.watchDate &&
          other.marked == this.marked);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> image;
  final Value<String> name;
  final Value<String> type;
  final Value<int> currentEp;
  final Value<String> genre;
  final Value<String> epNum;
  final Value<int> fsk;
  final Value<int> prodYear;
  final Value<DateTime> addDate;
  final Value<DateTime> watchDate;
  final Value<int> marked;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.image = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.currentEp = const Value.absent(),
    this.genre = const Value.absent(),
    this.epNum = const Value.absent(),
    this.fsk = const Value.absent(),
    this.prodYear = const Value.absent(),
    this.addDate = const Value.absent(),
    this.watchDate = const Value.absent(),
    this.marked = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    @required String image,
    @required String name,
    @required String type,
    @required int currentEp,
    @required String genre,
    @required String epNum,
    @required int fsk,
    @required int prodYear,
    @required DateTime addDate,
    this.watchDate = const Value.absent(),
    this.marked = const Value.absent(),
  })  : image = Value(image),
        name = Value(name),
        type = Value(type),
        currentEp = Value(currentEp),
        genre = Value(genre),
        epNum = Value(epNum),
        fsk = Value(fsk),
        prodYear = Value(prodYear),
        addDate = Value(addDate);
  static Insertable<Favorite> custom({
    Expression<int> id,
    Expression<String> image,
    Expression<String> name,
    Expression<String> type,
    Expression<int> currentEp,
    Expression<String> genre,
    Expression<String> epNum,
    Expression<int> fsk,
    Expression<int> prodYear,
    Expression<DateTime> addDate,
    Expression<DateTime> watchDate,
    Expression<int> marked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (image != null) 'image': image,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (currentEp != null) 'current_ep': currentEp,
      if (genre != null) 'genre': genre,
      if (epNum != null) 'ep_num': epNum,
      if (fsk != null) 'fsk': fsk,
      if (prodYear != null) 'prod_year': prodYear,
      if (addDate != null) 'add_date': addDate,
      if (watchDate != null) 'watch_date': watchDate,
      if (marked != null) 'marked': marked,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int> id,
      Value<String> image,
      Value<String> name,
      Value<String> type,
      Value<int> currentEp,
      Value<String> genre,
      Value<String> epNum,
      Value<int> fsk,
      Value<int> prodYear,
      Value<DateTime> addDate,
      Value<DateTime> watchDate,
      Value<int> marked}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      type: type ?? this.type,
      currentEp: currentEp ?? this.currentEp,
      genre: genre ?? this.genre,
      epNum: epNum ?? this.epNum,
      fsk: fsk ?? this.fsk,
      prodYear: prodYear ?? this.prodYear,
      addDate: addDate ?? this.addDate,
      watchDate: watchDate ?? this.watchDate,
      marked: marked ?? this.marked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currentEp.present) {
      map['current_ep'] = Variable<int>(currentEp.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (epNum.present) {
      map['ep_num'] = Variable<String>(epNum.value);
    }
    if (fsk.present) {
      map['fsk'] = Variable<int>(fsk.value);
    }
    if (prodYear.present) {
      map['prod_year'] = Variable<int>(prodYear.value);
    }
    if (addDate.present) {
      final converter = $FavoritesTable.$converter0;
      map['add_date'] = Variable<String>(converter.mapToSql(addDate.value));
    }
    if (watchDate.present) {
      final converter = $FavoritesTable.$converter1;
      map['watch_date'] = Variable<String>(converter.mapToSql(watchDate.value));
    }
    if (marked.present) {
      map['marked'] = Variable<int>(marked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('currentEp: $currentEp, ')
          ..write('genre: $genre, ')
          ..write('epNum: $epNum, ')
          ..write('fsk: $fsk, ')
          ..write('prodYear: $prodYear, ')
          ..write('addDate: $addDate, ')
          ..write('watchDate: $watchDate, ')
          ..write('marked: $marked')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavoritesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedColumn<int> _id;
  @override
  GeneratedColumn<int> get id =>
      _id ??= GeneratedColumn<int>('id', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  GeneratedColumn<String> _image;
  @override
  GeneratedColumn<String> get image =>
      _image ??= GeneratedColumn<String>('image', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedColumn<String> _name;
  @override
  GeneratedColumn<String> get name =>
      _name ??= GeneratedColumn<String>('name', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedColumn<String> _type;
  @override
  GeneratedColumn<String> get type =>
      _type ??= GeneratedColumn<String>('type', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _currentEpMeta = const VerificationMeta('currentEp');
  GeneratedColumn<int> _currentEp;
  @override
  GeneratedColumn<int> get currentEp =>
      _currentEp ??= GeneratedColumn<int>('current_ep', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _genreMeta = const VerificationMeta('genre');
  GeneratedColumn<String> _genre;
  @override
  GeneratedColumn<String> get genre =>
      _genre ??= GeneratedColumn<String>('genre', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _epNumMeta = const VerificationMeta('epNum');
  GeneratedColumn<String> _epNum;
  @override
  GeneratedColumn<String> get epNum =>
      _epNum ??= GeneratedColumn<String>('ep_num', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _fskMeta = const VerificationMeta('fsk');
  GeneratedColumn<int> _fsk;
  @override
  GeneratedColumn<int> get fsk =>
      _fsk ??= GeneratedColumn<int>('fsk', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _prodYearMeta = const VerificationMeta('prodYear');
  GeneratedColumn<int> _prodYear;
  @override
  GeneratedColumn<int> get prodYear =>
      _prodYear ??= GeneratedColumn<int>('prod_year', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _addDateMeta = const VerificationMeta('addDate');
  GeneratedColumnWithTypeConverter<DateTime, String> _addDate;
  @override
  GeneratedColumnWithTypeConverter<DateTime, String> get addDate =>
      _addDate ??= GeneratedColumn<String>('add_date', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<DateTime>($FavoritesTable.$converter0);
  final VerificationMeta _watchDateMeta = const VerificationMeta('watchDate');
  GeneratedColumnWithTypeConverter<DateTime, String> _watchDate;
  @override
  GeneratedColumnWithTypeConverter<DateTime, String> get watchDate =>
      _watchDate ??= GeneratedColumn<String>('watch_date', aliasedName, false,
              typeName: 'TEXT',
              requiredDuringInsert: false,
              defaultValue: Constant("01.01.1995 10:00:00"))
          .withConverter<DateTime>($FavoritesTable.$converter1);
  final VerificationMeta _markedMeta = const VerificationMeta('marked');
  GeneratedColumn<int> _marked;
  @override
  GeneratedColumn<int> get marked =>
      _marked ??= GeneratedColumn<int>('marked', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        image,
        name,
        type,
        currentEp,
        genre,
        epNum,
        fsk,
        prodYear,
        addDate,
        watchDate,
        marked
      ];
  @override
  String get aliasedName => _alias ?? 'favorites';
  @override
  String get actualTableName => 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image'], _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('current_ep')) {
      context.handle(_currentEpMeta,
          currentEp.isAcceptableOrUnknown(data['current_ep'], _currentEpMeta));
    } else if (isInserting) {
      context.missing(_currentEpMeta);
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre'], _genreMeta));
    } else if (isInserting) {
      context.missing(_genreMeta);
    }
    if (data.containsKey('ep_num')) {
      context.handle(
          _epNumMeta, epNum.isAcceptableOrUnknown(data['ep_num'], _epNumMeta));
    } else if (isInserting) {
      context.missing(_epNumMeta);
    }
    if (data.containsKey('fsk')) {
      context.handle(
          _fskMeta, fsk.isAcceptableOrUnknown(data['fsk'], _fskMeta));
    } else if (isInserting) {
      context.missing(_fskMeta);
    }
    if (data.containsKey('prod_year')) {
      context.handle(_prodYearMeta,
          prodYear.isAcceptableOrUnknown(data['prod_year'], _prodYearMeta));
    } else if (isInserting) {
      context.missing(_prodYearMeta);
    }
    context.handle(_addDateMeta, const VerificationResult.success());
    context.handle(_watchDateMeta, const VerificationResult.success());
    if (data.containsKey('marked')) {
      context.handle(_markedMeta,
          marked.isAcceptableOrUnknown(data['marked'], _markedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String tablePrefix}) {
    return Favorite.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(_db, alias);
  }

  static TypeConverter<DateTime, String> $converter0 = DateConverter();
  static TypeConverter<DateTime, String> $converter1 = DateConverter();
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FavoritesTable _favorites;
  $FavoritesTable get favorites => _favorites ??= $FavoritesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favorites];
}
