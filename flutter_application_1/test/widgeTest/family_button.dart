import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/widgets/family_button.dart';

void main() {
  testWidgets('FamilyButton displays label', (WidgetTester tester) async {
    const testLabel = 'Test Label';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamilyButton(
            label: testLabel,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ),
    );

    expect(find.text(testLabel), findsOneWidget);
  });

  testWidgets('FamilyButton navigates to targetPage when pressed', (WidgetTester tester) async {
    const testLabel = 'Navigate';
    final targetPage = Scaffold(appBar: AppBar(title: const Text('Target Page')));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamilyButton(
            label: testLabel,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            targetPage: targetPage,
          ),
        ),
      ),
    );

    await tester.tap(find.text(testLabel));
    await tester.pumpAndSettle();

    expect(find.text('Target Page'), findsOneWidget);
  });

  testWidgets('FamilyButton calls onPressed callback when pressed', (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamilyButton(
            label: 'Press me',
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Press me'));
    await tester.pump();

    expect(wasPressed, isTrue);
  });
}