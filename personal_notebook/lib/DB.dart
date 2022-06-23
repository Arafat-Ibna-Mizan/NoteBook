import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Diary.dart';

class DB {
  static Database _database;
  final String table = 'NoteBook';
  final int version = 1;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var dir = await getDatabasesPath();
    String path = join(dir, 'dairy_NoteBook.db');
    Database openDB = await openDatabase(path, version: version,
        onCreate: (Database db, int version) {
      db.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,body TEXT,date TEXT)');
    });
    return openDB;
  }

  Future<void> save(Diary diary) async {
    Database db = await database;
    await db.insert(table, diary.toMap());
  }

  Future<void> update(Diary diary) async {
    Database db = await database;
    await db.update(table, diary.toMap(), where: 'id=?', whereArgs: [diary.id]);
  }

  Future<void> delete(Diary diary) async {
    Database db = await database;
    await db.delete(table, where: 'id=?', whereArgs: [diary.id]);
  }

  Future<List<Diary>> getDiaryList() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table);
    List<Diary> diaryList = <Diary>[];
    for (var map in maps) diaryList.add(Diary.fromtap(map));
    return diaryList;
  }
}
