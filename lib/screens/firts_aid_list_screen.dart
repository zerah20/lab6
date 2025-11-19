import 'package:flutter/material.dart';
import '../controller/firts_aid_controller.dart';
import '../models/first_aid_case.dart';
import 'first_aid_edit_screen.dart';

class FirstAidListScreen extends StatefulWidget {
  const FirstAidListScreen({super.key});

  @override
  State<FirstAidListScreen> createState() => _FirstAidListScreenState();
}

class _FirstAidListScreenState extends State<FirstAidListScreen> {
  final controller = FirstAidController();
  List<FirstAidCase> list = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    list = await controller.fetchCases();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("First Aid Cases")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FirstAidEditScreen(onSaved: load)),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: list.map((caseItem) {
          return ListTile(
            title: Text(caseItem.title),
            subtitle: Text(caseItem.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await controller.deleteCase(caseItem.id);
                load();
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FirstAidEditScreen(
                      existing: caseItem,
                      onSaved: load,
                    )),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
