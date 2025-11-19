import 'package:flutter/material.dart';

class CoralButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CoralButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
