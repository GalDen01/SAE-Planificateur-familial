import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/list_add_button.dart';

void main() {
  testWidgets('ListAddButton shows dialog on button press', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ListProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: ListAddButton(
              cardColor: Colors.blue,
              grayColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Verify the button is present
    expect(find.text('Ajouter une liste'), findsOneWidget);

    // Tap the button and trigger a frame
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify the dialog is shown
    expect(find.text('Ajouter une liste de course'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('ListAddButton adds list on valid input', (WidgetTester tester) async {
    final listProvider = ListProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: listProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ListAddButton(
              cardColor: Colors.blue,
              grayColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Tap the button and trigger a frame
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Enter text in the TextField
    await tester.enterText(find.byType(TextField), 'New List');
    await tester.pump();

    // Tap the 'Ajouter' button
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    // Verify the list was added
    expect(listProvider.lists.contains('New List'), isTrue);
  });

  testWidgets('ListAddButton does not add list on empty input', (WidgetTester tester) async {
    final listProvider = ListProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: listProvider,
        child: MaterialApp(
          home: Scaffold(
            body: ListAddButton(
              cardColor: Colors.blue,
              grayColor: Colors.white,
            ),
          ),
        ),
      ),
    );

    // Tap the button and trigger a frame
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Tap the 'Ajouter' button without entering text
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    // Verify the list was not added
    expect(listProvider.lists.isEmpty, isTrue);
  });
}