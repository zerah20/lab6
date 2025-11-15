// lib/db/database_helper.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/first_aid.dart';
import '../db/database_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  final SupabaseClient _supabase = Supabase.instance.client;

  static const String tableFirstAid = 'first_aid';
  static const String storageBucket = 'first-aid-images';

  /// ─── UPLOAD IMAGE ─────────────────────────────
  /// Accepts mobile File or web Uint8List
  Future<String?> uploadImage({
    File? file,
    Uint8List? bytes,
    required String filePath,
  }) async {
    try {
      final bucket = _supabase.storage.from(storageBucket);

      if (kIsWeb) {
        if (bytes == null) return null;
        await bucket.uploadBinary(filePath, bytes);
      } else {
        if (file == null) return null;
        await bucket.upload(filePath, file);
      }

      final url = bucket.getPublicUrl(filePath);
      return url; // returns String
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  /// ─── CREATE ─────────────────────────────
  Future<FirstAid> createFirstAid(FirstAid item) async {
    final now = DateTime.now().toIso8601String();

    final response = await _supabase
        .from(tableFirstAid)
        .insert({
      'title': item.title,
      'description': item.description,
      'instructions': item.instructions,
      'image_path': item.imagePath,
      'created_at': now,
      'updated_at': now,
    })
        .select()
        .single();

    return FirstAid.fromMap(response);
  }

  /// ─── READ ALL ─────────────────────────────
  Future<List<FirstAid>> readAllFirstAids() async {
    final res = await _supabase
        .from(tableFirstAid)
        .select()
        .order('created_at', ascending: false);

    return (res as List).map((e) => FirstAid.fromMap(e)).toList();
  }

  /// ─── READ ONE BY ID ─────────────────────────────
  Future<FirstAid?> readFirstAid(int id) async {
    final res = await _supabase
        .from(tableFirstAid)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (res == null) return null;
    return FirstAid.fromMap(res);
  }

  /// ─── UPDATE ─────────────────────────────
  Future<int> updateFirstAid(FirstAid item) async {
    item.updatedAt = DateTime.now();

    try {
      await _supabase.from(tableFirstAid).update({
        'title': item.title,
        'description': item.description,
        'instructions': item.instructions,
        'image_path': item.imagePath,
        'updated_at': item.updatedAt.toIso8601String(),
      }).eq('id', item.id);

      return 1;
    } catch (e) {
      print('Supabase update error: $e');
      return 0;
    }
  }

  /// ─── DELETE ─────────────────────────────
  Future<int> deleteFirstAid(int id) async {
    try {
      await _supabase.from(tableFirstAid).delete().eq('id', id);
      return 1;
    } catch (e) {
      print('Supabase delete error: $e');
      return 0;
    }
  }
}
