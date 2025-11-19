import 'package:flutter/material.dart';
import '../widget/rounded_background.dart';
import '../widget/coral_button.dart';
import 'firts_aid_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RoundedBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("First Aid Quick Guide",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                const Text("Your medical helper in emergencies."),
                const SizedBox(height: 40),
                CoralButton(
                  text: "Open First Aid Guide",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FirstAidListScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
