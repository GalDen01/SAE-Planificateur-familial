import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_lists_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/manage_members_screen.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';

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
            FamilyButton(
              label: "Quitter la famille",
              backgroundColor: cardColor,
              textColor: grayColor,
              onPressed: () async {
                final familyProvider = context.read<FamilyProvider>();
                try {
                  final currentUser = Supabase.instance.client.auth.currentUser;
                  if (currentUser == null || currentUser.id.isEmpty) {
                    throw Exception("Utilisateur non connecté.");
                  }

                  // Supprime l'utilisateur de la famille
                  await familyProvider.deleteMemberToFamilyByUserId(
                    familyId,
                    currentUser.id,
                  );

                  // Affiche un message de succès
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vous avez quitté la famille avec succès!'),
                    ),
                  );

                  // Retour à l'écran précédent
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
