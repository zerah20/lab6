// lib/screens/add_edit_screen.dart
import 'package:flutter/material.dart';
import '../models/first_aid.dart';
import '../db/database_helper.dart';

// Image picker mobile only
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddEditScreen extends StatefulWidget {
  final FirstAid? existing;
  const AddEditScreen({Key? key, this.existing}) : super(key: key);

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _imagePath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.existing?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existing?.description ?? '');
    _imagePath = widget.existing?.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Pick image (mobile only)
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? xfile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

      if (xfile == null) return;

      final temp = File(xfile.path);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(xfile.path)}';
      final saved = await temp.copy('${appDir.path}/$fileName');

      setState(() => _imagePath = saved.path);
    } catch (e) {
      // Safe fallback for web
      debugPrint("Image picker not supported on this platform.");
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final helper = DatabaseHelper.instance;

    if (widget.existing == null) {
      // Create new record
      final newItem = FirstAid(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        instructions:
        '', // blank instructions since not used anymore
        imagePath: _imagePath,
      );
      await helper.createFirstAid(newItem);
    } else {
      // Update existing
      final updated = widget.existing!;
      updated.title = _titleController.text.trim();
      updated.description = _descriptionController.text.trim();
      updated.instructions = ''; // empty
      updated.imagePath = _imagePath;

      await helper.updateFirstAid(updated);
    }

    setState(() => _saving = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Item" : "Add Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (ex: Bleeding)',
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Enter a title" : null,
              ),

              const SizedBox(height: 12),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Short description',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? "Enter a short description"
                    : null,
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              // IMAGE PICKER
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Select Image"),
              ),

              const SizedBox(height: 10),

              if (_imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_imagePath!),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              // SAVE BUTTON
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const CircularProgressIndicator()
                    : Text(isEditing ? "Update" : "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
