import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ybmlutkwwkypdlqxrbdv.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlibWx1dGt3d2t5cGRscXhyYmR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTk4NDgsImV4cCI6MjA3ODY3NTg0OH0.146LQ7A6sOI5I8DahfCVJQv_kyeaTKQ8JxvxaKUkVBY',
  );

  runApp(const FirstAidApp());
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "First Aid Quick Guide",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(),
      home: const SplashScreen(),
    );
  }
}
