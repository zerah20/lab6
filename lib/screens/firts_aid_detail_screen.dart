import 'package:flutter/material.dart';
import '../models/first_aid_case.dart';
import '../services/supabase_service.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final FirstAidCase caseItem;

  const FirstAidDetailScreen({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final imageUrl = caseItem.imagePath != null
        ? SupabaseService.getPublicImageUrl(caseItem.imagePath!)
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- HEADER IMAGE ----------------
            imageUrl != null
                ? Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.contain,   // <-- SHOW FULL IMAGE
            )
                : Container(
              height: 200,
              width: double.infinity,
              color: Colors.red.shade200,
              child: const Icon(
                Icons.medical_services,
                size: 120,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // ---------------- CONTENT CONTAINER ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- TITLE ----------
                  Text(
                    caseItem.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- DESCRIPTION ----------
                  Text(
                    caseItem.description,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ---------- FOOTER ----------
                  Center(
                    child: Text(
                      "First Aid Quick Guide",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // BACK BUTTON FLOATING ON TOP
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Align(
          alignment: Alignment.topLeft,
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.red),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
