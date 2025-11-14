// lib/db/database_helper.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/first_aid.dart';

// Only import sqflite + file system on mobile platforms
// because they do NOT work on Flutter Web
// and cause “Cannot send Null” errors.
import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// --------------------------------------------------------------------------------
/// WEB DATABASE (FAKE IN-MEMORY DB)
/// --------------------------------------------------------------------------------

class WebDB {
  static final WebDB instance = WebDB._internal();
  WebDB._internal();

  final List<Map<String, dynamic>> _items = [];

  Future<void> init() async {
    // Load preloaded.json
    final data = await rootBundle.loadString('assets/preloaded.json');
    final list = json.decode(data);

    _items.clear();

    final now = DateTime.now().toIso8601String();

    for (final item in list) {
      _items.add({
        'id': _items.length + 1,
        'title': item['title'],
        'description': item['description'],
        'instructions': item['instructions'],
        'image_path': null,
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  List<Map<String, dynamic>> getAll() => _items;

  Map<String, dynamic>? getById(int id) =>
      _items.firstWhere((e) => e['id'] == id, orElse: () => {});

  int insert(Map<String, dynamic> map) {
    map['id'] = _items.length + 1;
    _items.add(map);
    return map['id'];
  }

  int update(Map<String, dynamic> map) {
    final index = _items.indexWhere((e) => e['id'] == map['id']);
    if (index != -1) {
      _items[index] = map;
    }
    return 1;
  }

  int delete(int id) {
    _items.removeWhere((e) => e['id'] == id);
    return 1;
  }
}

/// --------------------------------------------------------------------------------
/// MOBILE DATABASE (SQFLITE)
/// --------------------------------------------------------------------------------

Future<void> seedAdditionalTopics(Database db) async {
  final data = await rootBundle.loadString('assets/preloaded.json');
  final List list = json.decode(data);
  final now = DateTime.now().toIso8601String();

  for (final item in list) {
    await db.insert(DatabaseHelper.tableFirstAid, {
      'title': item['title'],
      'description': item['description'],
      'instructions': item['instructions'],
      'image_path': null,
      'created_at': now,
      'updated_at': now,
    });
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  static const String tableFirstAid = 'first_aid';

  Future<dynamic> get database async {
    // ---------------- WEB FIX ----------------
    if (kIsWeb) {
      await WebDB.instance.init();
      return WebDB.instance;
    }
    // -----------------------------------------

    if (_db != null) return _db!;
    _db = await _initDB('first_aid.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFirstAid (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        instructions TEXT NOT NULL,
        image_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await seedAdditionalTopics(db);
  }

  // --------------------------------------------------------------------------------
  // CRUD (Works for both MOBILE & WEB)
  // --------------------------------------------------------------------------------

  Future<FirstAid> createFirstAid(FirstAid item) async {
    final db = await database;

    if (kIsWeb) {
      int id = db.insert(item.toMap());
      item.id = id;
      return item;
    }

    final id = await (db as Database).insert(tableFirstAid, item.toMap());
    item.id = id;
    return item;
  }

  Future<FirstAid?> readFirstAid(int id) async {
    final db = await database;

    if (kIsWeb) {
      final row = db.getById(id);
      if (row == null) return null;
      return FirstAid.fromMap(row);
    }

    final maps = await (db as Database).query(
      tableFirstAid,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) return FirstAid.fromMap(maps.first);
    return null;
  }

  Future<List<FirstAid>> readAllFirstAids({String? query}) async {
    final db = await database;

    if (kIsWeb) {
      final list = db.getAll();
      return list.map((e) => FirstAid.fromMap(e)).toList();
    }

    final result = await (db as Database).query(
      tableFirstAid,
      orderBy: 'updated_at DESC',
    );

    return result.map((e) => FirstAid.fromMap(e)).toList();
  }

  Future<int> updateFirstAid(FirstAid item) async {
    final db = await database;
    item.updatedAt = DateTime.now();

    if (kIsWeb) {
      return db.update(item.toMap());
    }

    return (db as Database).update(
      tableFirstAid,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteFirstAid(int id) async {
    final db = await database;

    if (kIsWeb) return db.delete(id);

    return (db as Database).delete(
      tableFirstAid,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    if (!kIsWeb) {
      final db = await database;
      await (db as Database).close();
    }
  }
}
