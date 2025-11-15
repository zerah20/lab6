import 'package:flutter/material.dart';
import '../models/first_aid.dart';
import '../db/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  final FirstAid? firstAidItem; // <--- Add this

  const AddEditScreen({Key? key, this.firstAidItem}) : super(key: key); // <--- Add this

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController instructionsController;

  final db = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
        text: widget.firstAidItem?.title ?? '');
    descriptionController = TextEditingController(
        text: widget.firstAidItem?.description ?? '');
    instructionsController = TextEditingController(
        text: widget.firstAidItem?.instructions ?? '');
  }

  void saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = FirstAid(
        id: widget.firstAidItem?.id,
        title: titleController.text,
        description: descriptionController.text,
        instructions: instructionsController.text,
        imagePath: widget.firstAidItem?.imagePath,
        createdAt: widget.firstAidItem?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.firstAidItem == null) {
        await db.createFirstAid(item);
      } else {
        await db.updateFirstAid(item);
      }

      Navigator.pop(context); // Go back to HomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.firstAidItem == null ? 'Add First Aid' : 'Edit First Aid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter instructions' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveItem,
                child: Text(widget.firstAidItem == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
