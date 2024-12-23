import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class FamilyDetailsScreen extends StatelessWidget {
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const FamilyDetailsScreen({
    super.key,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context), 
      ),
      backgroundColor: grayColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Nom de la famille
            Text(
              familyName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cardColor,
              ),
            ),
            const SizedBox(height: 20),

            // Image (CircleAvatar)
            CircleAvatar(
              radius: 40.0,
              backgroundColor: cardColor,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/famille.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40),

            FamilyButton(
              label: "Listes de courses",
              backgroundColor: cardColor,
              textColor: grayColor,
              targetPage: GroceryListsScreen(
                familyName: familyName,
                cardColor: cardColor,
                grayColor: grayColor,
                brightCardColor: brightCardColor,
              ),
            ),
            const SizedBox(height: 10),

            FamilyButton(
              label: "Tâches à faire",
              backgroundColor: cardColor,
              textColor: grayColor,
              targetPage: TodoListsScreen(
                familyName: familyName,
                cardColor: cardColor,
                grayColor: grayColor,
                brightCardColor: brightCardColor,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
