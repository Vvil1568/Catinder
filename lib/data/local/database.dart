import 'dart:convert';
import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/domain/entities/liked_cat_entity.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class LikedCats extends Table {
  TextColumn get id => text()();

  TextColumn get catData => text().map(const CatConverter())();

  DateTimeColumn get likedDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedCats extends Table {
  TextColumn get id => text()();

  TextColumn get imageData => text()();

  TextColumn get breedData => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class CatConverter extends TypeConverter<CatImageEntity, String> {
  const CatConverter();

  @override
  CatImageEntity fromSql(String fromDb) {
    return CatImageEntity.fromJson(jsonDecode(fromDb));
  }

  @override
  String toSql(CatImageEntity value) {
    return jsonEncode(value.toJson());
  }
}

@DriftDatabase(tables: [LikedCats, CachedCats])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> addLikedCat(LikedCatEntity cat) async {
    await into(likedCats).insert(
      LikedCatsCompanion(
        id: Value(cat.catImage.id),
        catData: Value(cat.catImage),
        likedDate: Value(cat.likedDate),
      ),
    );
  }

  Future<void> removeLikedCat(String id) =>
      (delete(likedCats)..where((t) => t.id.equals(id))).go();

  Future<List<LikedCat>> getLikedCats() => select(likedCats).get();

  Future<void> cacheCat(CatImageEntity cat) async {
    await into(cachedCats).insert(
      CachedCatsCompanion.insert(
        id: cat.id,
        imageData: jsonEncode(cat.toJson()),
        breedData: jsonEncode(cat.breed.toJson()),
      ),
      mode: InsertMode.replace,
    );
  }

  Future<List<CatImageEntity>> getCachedCats() async {
    final cached = await select(cachedCats).get();
    return cached.map((c) {
      return CatImageEntity.fromJson(jsonDecode(c.imageData));
    }).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
