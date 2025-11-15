import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ybmlutkwwkypdlqxrbdv.supabase.co',         // Replace with your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlibWx1dGt3d2t5cGRscXhyYmR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwOTk4NDgsImV4cCI6MjA3ODY3NTg0OH0.146LQ7A6sOI5I8DahfCVJQv_kyeaTKQ8JxvxaKUkVBY', // Replace with your Supabase anon key
  );

  runApp(const FirstAidApp());
}

class FirstAidApp extends StatelessWidget {
  const FirstAidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Aid Quick Guide',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
