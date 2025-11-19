import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/first_aid_case.dart';

class SupabaseService {
  static final _client = Supabase.instance.client;

  static const String table = 'first_aid';
  static const String bucket = 'imagaes';


  static Future<List<FirstAidCase>> fetchCases() async {
    final response = await _client
        .from(table)
        .select('*')
        .order('created_at', ascending: false);

    return (response as List)
        .map<FirstAidCase>((e) => FirstAidCase.fromMap(e))
        .toList();
  }


  static Future<void> addCase(
      String title, String description, String? imagePath) async {
    await _client.from(table).insert({
      'title': title,
      'description': description,
      'image_path': imagePath,
    });
  }


  static Future<void> updateCase(
      String id, String title, String description, String? imagePath) async {
    await _client.from(table).update({
      'title': title,
      'description': description,
      'image_path': imagePath,
    }).eq('id', id);
  }

  static Future<void> deleteCase(String id) async {
    await _client.from(table).delete().eq('id', id);
  }


  static Future<String> uploadImage(Uint8List fileBytes) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = 'images/$fileName'; // folder inside bucket

    await _client.storage.from(bucket).uploadBinary(
      filePath,
      fileBytes,
      fileOptions: const FileOptions(
        upsert: false,
        contentType: 'image/jpeg',
      ),
    );

    return filePath;
  }


  static String getPublicImageUrl(String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }
}
