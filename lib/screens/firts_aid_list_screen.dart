import 'package:flutter/material.dart';
import '../controller/firts_aid_controller.dart';
import '../models/first_aid_case.dart';
import '../services/supabase_service.dart';
import 'firts_aid_detail_screen.dart';  // <-- FIXED IMPORT

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
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "First Aid Cases",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.medical_services_outlined, size: 28),
      ),
      body: list.isEmpty
          ? Center(
        child: Text(
          "No cases available",
          style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = list[index];

          final imageUrl = item.imagePath != null
              ? SupabaseService.getPublicImageUrl(item.imagePath!)
              : null;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FirstAidDetailScreen(caseItem: item),
                ),
              );
            },
            child: Card(
              elevation: 3,
              shadowColor: Colors.red.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 100,
                      height: 100,
                      color: Colors.red.shade100,
                      child: const Icon(
                        Icons.medical_information,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // TEXT
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // DELETE BUTTON REMOVED
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
