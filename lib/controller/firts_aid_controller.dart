import '../models/first_aid_case.dart';
import '../services/supabase_service.dart';

class FirstAidController {
  Future<List<FirstAidCase>> fetchCases() async {
    return SupabaseService.fetchCases();
  }

  Future<void> addCase(
      String title, String description, String? imagePath) async {
    await SupabaseService.addCase(title, description, imagePath);
  }

  Future<void> updateCase(
      String id, String title, String description, String? imagePath) async {
    await SupabaseService.updateCase(id, title, description, imagePath);
  }

  Future<void> deleteCase(String id) async {
    await SupabaseService.deleteCase(id);
  }
}
