

import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_lists_screen.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/manage_members_screen.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class FamilyDetailsScreen extends StatelessWidget {
  final int familyId;
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const FamilyDetailsScreen({
    super.key,
    required this.familyId,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personnalisé
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

            Text(
              familyName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 10),

            // Image (CircleAvatar) - adaptable à tes ressources
            CircleAvatar(
              radius: 40.0,
              backgroundColor: cardColor,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/famille.png', // à adapter si besoin
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Bouton vers la page des listes de courses
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

            // Bouton vers la page to-do
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

            // Bouton vers la page de gestion des membres
            FamilyButton(
              label: "Gérer les membres",
              backgroundColor: cardColor,
              textColor: grayColor,
              targetPage: ManageMembersScreen(
                familyId: familyId,
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
