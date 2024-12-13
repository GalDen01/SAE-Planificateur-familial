import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../../lib/src/providers/family_provider.dart';
import '../../lib/src/widgets/family_add_button.dart';

void main() {
  testWidgets('FamilyAddButton shows dialog on button press', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FamilyProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: FamilyAddButton(
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Verify the button is present
    expect(find.text('Ajouter une famille'), findsOneWidget);

    // Tap the button and trigger a frame
    await tester.tap(find.text('Ajouter une famille'));
    await tester.pumpAndSettle();

    // Verify the dialog is shown
    expect(find.text('Créer une famille'), findsOneWidget);
    expect(find.text('Nom de la famille'), findsOneWidget);
  });

  testWidgets('FamilyAddButton adds family on valid input', (WidgetTester tester) async {
    final familyProvider = FamilyProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => familyProvider,
        child: MaterialApp(
          home: Scaffold(
            body: FamilyAddButton(
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Tap the button and trigger a frame
    await tester.tap(find.text('Ajouter une famille'));
    await tester.pumpAndSettle();

    // Enter a family name
    await tester.enterText(find.byType(TextField), 'Test Family');
    await tester.pump();

    // Tap the 'Ajouter' button
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    // Verify the family was added
    expect(familyProvider.families.contains('Test Family'), isTrue);
  });

  testWidgets('FamilyAddButton does not add family on empty input', (WidgetTester tester) async {
    final familyProvider = FamilyProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => familyProvider,
        child: MaterialApp(
          home: Scaffold(
            body: FamilyAddButton(
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Tap the button and trigger a frame
    await tester.tap(find.text('Ajouter une famille'));
    await tester.pumpAndSettle();

    // Tap the 'Ajouter' button without entering a family name
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    // Verify the family was not added
    expect(familyProvider.families.contains(''), isFalse);
  });
}