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

class FamilyDetailsScreen extends StatefulWidget {
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
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  void _confirmLeaveFamily(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Quitter la famille ?",
            style: TextStyle(color: widget.grayColor),
          ),
          backgroundColor: widget.cardColor,
          content: Text(
            "Voulez-vous vraiment quitter la famille '${widget.familyName}' ?",
            style: TextStyle(color: widget.grayColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
              ),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                final auth = context.read<AuthProvider>();
                final familyProvider = context.read<FamilyProvider>();
                final currentNavigator = Navigator.of(context);
                final currentScaffoldMessenger = ScaffoldMessenger.of(context);

                Navigator.pop(ctx);

                final userEmail = auth.currentUser?.email;
                if (userEmail == null) {
                  currentScaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Utilisateur non identifié !')),
                  );
                  return;
                }

                try {
                  await familyProvider.leaveFamily(widget.familyId, userEmail);
                  currentScaffoldMessenger.showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Vous avez quitté la famille avec succès !')),
                  );
                  currentNavigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  currentScaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Erreur : ${e.toString()}')),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
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
      backgroundColor: widget.grayColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              widget.familyName,
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
                      color: widget.cardColor,
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
              backgroundColor: widget.cardColor,
              textColor: widget.grayColor,
              targetPage: GroceryListsScreen(
                familyId: widget.familyId,
                familyName: widget.familyName,
                cardColor: widget.cardColor,
                grayColor: widget.grayColor,
                brightCardColor: widget.brightCardColor,
              ),
            ),
            const SizedBox(height: 10),
            FamilyButton(
              label: "Tâches à faire",
              backgroundColor: widget.cardColor,
              textColor: widget.grayColor,
              targetPage: TodoListsScreen(
                familyId: widget.familyId,
                familyName: widget.familyName,
                cardColor: widget.cardColor,
                grayColor: widget.grayColor,
                brightCardColor: widget.brightCardColor,
              ),
            ),
            const SizedBox(height: 10),
            FamilyButton(
              label: "Mon Groupe Familial",
              backgroundColor: widget.cardColor,
              textColor: widget.grayColor,
              targetPage: ManageMembersScreen(
                familyId: widget.familyId,
                familyName: widget.familyName,
                cardColor: widget.cardColor,
                grayColor: widget.grayColor,
                brightCardColor: widget.brightCardColor,
              ),
            ),
            const SizedBox(height: 10),
            FamilyButton(
              label: "Quitter la famille",
              backgroundColor: widget.cardColor,
              textColor: widget.grayColor,
              onPressed: () => _confirmLeaveFamily(context),
            ),
          ],
        ),
      ),
    );
  }
}
