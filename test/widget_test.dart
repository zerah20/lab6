// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_aid_quick_guide/main.dart';  // <-- uses your real MyApp

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the main app
    await tester.pumpWidget(const FirstAidApp());

    // Verify that the counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the "+" icon
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter increments
    expect(find.text('1'), findsOneWidget);
  });
}
