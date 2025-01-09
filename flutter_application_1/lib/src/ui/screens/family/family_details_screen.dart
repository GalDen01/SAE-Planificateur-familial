// lib/src/ui/screens/family/family_details_screen.dart

import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/manage_members_screen.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/ui/screens/home/home_screen.dart';

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

  /// Affiche une boîte de dialogue pour confirmer le départ de la famille
  void _confirmLeaveFamily(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Quitter la famille ?",
            style: TextStyle(color: grayColor),
          ),
          backgroundColor: cardColor,
          content: Text(
            "Voulez-vous vraiment quitter la famille '$familyName' ?",
            style: TextStyle(color: grayColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), // Annuler
              style: TextButton.styleFrom(
                foregroundColor: grayColor,
                backgroundColor: cardColor,
              ),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx); // Fermer la boîte de dialogue

                // On récupère l'email de l'utilisateur connecté
                final userEmail = context.read<AuthProvider>().currentUser?.email;
                if (userEmail == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Utilisateur non identifié !')),
                  );
                  return;
                }

                try {
                  // Appel au Provider pour quitter la famille
                  await context.read<FamilyProvider>().leaveFamily(familyId, userEmail);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vous avez quitté la famille avec succès !')),
                  );

                  // Revenir à l'écran principal
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : ${e.toString()}')),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: grayColor,
                backgroundColor: cardColor,
              ),
              child: const Text("Quitter"),
            ),
          ],
        );
      },
    );
  }

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
            Text(
              familyName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cardColor,
                    ),
                  ),
                  Positioned(
                    top: -1,
                    child: Image.asset(
                      'assets/images/famille.png',
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Bouton "Listes de courses"
            FamilyButton(
              label: "Listes de courses",
              backgroundColor: cardColor,
              textColor: grayColor,
              targetPage: GroceryListsScreen(
                familyId: familyId,
                familyName: familyName,
                cardColor: cardColor,
                grayColor: grayColor,
                brightCardColor: brightCardColor,
              ),
            ),
            const SizedBox(height: 10),

            // Bouton "Tâches à faire"
            FamilyButton(
              label: "Tâches à faire",
              backgroundColor: cardColor,
              textColor: grayColor,
              targetPage: TodoListsScreen(
                familyId: familyId,
                familyName: familyName,
                cardColor: cardColor,
                grayColor: grayColor,
                brightCardColor: brightCardColor,
              ),
            ),
            const SizedBox(height: 10),

            // Bouton "Gérer les membres"
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

            // Bouton "Quitter la famille" => Affiche la boîte de dialogue
            FamilyButton(
              label: "Quitter la famille",
              backgroundColor: cardColor,
              textColor: grayColor,
              onPressed: () => _confirmLeaveFamily(context),
            ),
          ],
        ),
      ),
    );
  }
}
