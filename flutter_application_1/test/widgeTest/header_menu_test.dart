import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/widgets/header_menu.dart';

void main() {
  testWidgets('HeaderMenu displays the correct title', (WidgetTester tester) async {
    const testTitle = 'Test Title';
    const testColor = Colors.black;
    const testFontSize = 24.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeaderMenu(
            title: testTitle,
            textColor: testColor,
            fontSize: testFontSize,
          ),
        ),
      ),
    );

    final titleFinder = find.text(testTitle);
    expect(titleFinder, findsOneWidget);
  });

  testWidgets('HeaderMenu uses the correct text color', (WidgetTester tester) async {
    const testTitle = 'Test Title';
    const testColor = Colors.red;
    const testFontSize = 24.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeaderMenu(
            title: testTitle,
            textColor: testColor,
            fontSize: testFontSize,
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text(testTitle));
    expect(textWidget.style?.color, testColor);
  });

  testWidgets('HeaderMenu uses the correct font size', (WidgetTester tester) async {
    const testTitle = 'Test Title';
    const testColor = Colors.black;
    const testFontSize = 30.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeaderMenu(
            title: testTitle,
            textColor: testColor,
            fontSize: testFontSize,
          ),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text(testTitle));
    expect(textWidget.style?.fontSize, testFontSize);
  });
}