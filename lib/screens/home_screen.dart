// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/first_aid.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<FirstAid> firstAidList = [];
  final db = DatabaseHelper.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFirstAidItems();
  }

  Future<void> fetchFirstAidItems() async {
    setState(() => isLoading = true);
    final items = await db.readAllFirstAids();
    setState(() {
      firstAidList = items;
      isLoading = false;
    });
  }

  void navigateToAddEdit([FirstAid? item]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreen(firstAidItem: item),
      ),
    );
    fetchFirstAidItems(); // Refresh list after returning
  }

  void deleteItem(int id) async {
    await db.deleteFirstAid(id);
    fetchFirstAidItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Quick Guide'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : firstAidList.isEmpty
          ? const Center(child: Text('No first aid items yet.'))
          : ListView.builder(
        itemCount: firstAidList.length,
        itemBuilder: (context, index) {
          final item = firstAidList[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                vertical: 5, horizontal: 10),
            child: ListTile(
              leading: item.imagePath != null
                  ? Image.network(
                item.imagePath!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.medical_services),
              title: Text(item.title),
              subtitle: Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => navigateToAddEdit(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteItem(item.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
