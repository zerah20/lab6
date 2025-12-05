import 'package:flutter/material.dart';
import '../controller/firts_aid_controller.dart';
import '../models/first_aid_case.dart';
import '../services/supabase_service.dart';
import '../screens/firts_aid_detail_screen.dart';

class FirstAidCase {
  final String id;
  final String title;
  final String description;
  final String? imagePath;

  FirstAidCase({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
  });

  factory FirstAidCase.fromMap(Map<String, dynamic> map) {
    return FirstAidCase(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['image_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_path': imagePath,
    };
  }
}
