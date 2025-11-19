import 'package:flutter/material.dart';
import '../app_theme.dart';

class RoundedBackground extends StatelessWidget {
  const RoundedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: AppTheme.background,
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: AppTheme.coral,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppTheme.coral,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
