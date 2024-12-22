import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/list_add_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_list_screen.dart';

class GroceryListsScreen extends StatelessWidget {
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryListsScreen({
    super.key,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<ListProvider>().lists; // List<GroceryListModel>

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: grayColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              // Pour centrer horizontalement
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  "Listes de courses de $familyName",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cardColor,
                  ),
                ),
                const SizedBox(height: 20),

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

                // déplie les elt de groceryList et les mets dans une liste de widget
                ...lists.map((groceryList) => Column(
                      children: [
                        FamilyButton(
                          label: groceryList.name,
                          backgroundColor: cardColor,
                          textColor: grayColor,
                          targetPage: GroceryListScreen(
                            listName: groceryList.name,
                            cardColor: cardColor,
                            grayColor: grayColor,
                            brightCardColor: brightCardColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),

                // Bouton d'ajout
                ListAddButton(
                  cardColor: cardColor,
                  grayColor: grayColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
