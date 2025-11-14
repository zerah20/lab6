// lib/db/database_helper.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/first_aid.dart';

import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


/// ============================================================================
/// WEB DATABASE (IN-MEMORY + SAMPLE OUTPUT)
/// ============================================================================
class WebDB {
  static final WebDB instance = WebDB._internal();
  WebDB._internal();

  final List<Map<String, dynamic>> _items = [];

  Future<void> init() async {
    _items.clear();

    final now = DateTime.now().toIso8601String();

    // ---- SAMPLE OUTPUT ITEMS (will always show) ----
    final sample = [
      {
        'title': 'CPR (Adult)',
        'description': 'Emergency CPR steps for adults.',
        'instructions':
        '1. Check responsiveness.\n2. Call emergency services.\n3. 30 chest compressions.\n4. 2 rescue breaths.\n5. Repeat until help arrives.',
      },
      {
        'title': 'Severe Bleeding',
        'description': 'How to stop heavy external bleeding.',
        'instructions':
        '1. Apply firm pressure.\n2. Elevate wound.\n3. Do NOT remove soaked cloth.\n4. Call emergency help.',
      },
      {
        'title': 'Choking (Adult)',
        'description': 'Heimlich maneuver instructions.',
        'instructions':
        '1. 5 back blows.\n2. 5 abdominal thrusts.\n3. Alternate until breathing returns.',
      },
      {
        'title': 'Minor Burns',
        'description': 'First aid for small burns.',
        'instructions':
        '1. Cool under water 20 minutes.\n2. Remove tight items.\n3. Cover with clean cloth.',
      },
      {
        'title': 'Fracture (Suspected)',
        'description': 'Handling possible broken bones.',
        'instructions':
        '1. Immobilize.\n2. Apply ice.\n3. Do not move limb.\n4. Seek medical care.',
      }
    ];

    // Insert sample
    for (var i = 0; i < sample.length; i++) {
      _items.add({
        'id': i + 1,
        'title': sample[i]['title'],
        'description': sample[i]['description'],
        'instructions': sample[i]['instructions'],
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
    if (index != -1) _items[index] = map;
    return 1;
  }

  int delete(int id) {
    _items.removeWhere((e) => e['id'] == id);
    return 1;
  }
}


/// ============================================================================
/// MOBILE DATABASE (SQFLITE + SAMPLE OUTPUT)
/// ============================================================================
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  static const String tableFirstAid = 'first_aid';

  Future<dynamic> get database async {
    if (kIsWeb) {
      await WebDB.instance.init();
      return WebDB.instance;
    }

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

    await _seedMobile(db);
  }

  /// MOBILE SAMPLE DATA
  Future<void> _seedMobile(Database db) async {
    final now = DateTime.now().toIso8601String();

    final sample = [
      {
        'title': 'Bleeding (External)',
        'description': 'How to manage external bleeding.',
        'instructions':
        '1. Apply direct pressure.\n2. Elevate injured area.\n3. Add more cloth if soaked.',
      },
      {
        'title': 'Burns (Minor)',
        'description': 'Treat minor burns.',
        'instructions':
        '1. Cool under water.\n2. Cover with sterile dressing.\n3. Avoid ice.',
      },
      {
        'title': 'Fracture (Suspected)',
        'description': 'How to stabilize fractures.',
        'instructions':
        '1. Immobilize.\n2. Apply ice with cloth.\n3. Get medical help.',
      }
    ];

    for (final item in sample) {
      await db.insert(tableFirstAid, {
        'title': item['title'],
        'description': item['description'],
        'instructions': item['instructions'],
        'image_path': null,
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  // ============================================================================
  // CRUD (Works for both mobile and web)
  // ============================================================================

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
      if (row.isEmpty) return null;
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
      return db.getAll().map((e) => FirstAid.fromMap(e)).toList();
    }

    final result = await (db as Database).query(
      tableFirstAid,
      orderBy: 'created_at DESC',
    );

    return result.map((e) => FirstAid.fromMap(e)).toList();
  }

  Future<int> updateFirstAid(FirstAid item) async {
    final db = await database;
    item.updatedAt = DateTime.now();

    if (kIsWeb) return db.update(item.toMap());

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
}
