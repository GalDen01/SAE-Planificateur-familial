import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/screens/grocery_list_screen.dart';
import 'package:Planificateur_Familial/src/widgets/family_button.dart';
import 'package:Planificateur_Familial/src/widgets/list_add_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroceryLists extends StatelessWidget {
  final String familyName; // ex: "Famille #3"

  const GroceryLists ({super.key, required this.familyName});

  @override
  Widget build(BuildContext context) {
    // Les mêmes couleurs que dans le menu principal
    const Color backgroundColor = Color(0xFF6D6D6D);
    const Color cardColor = Color(0xFFF2C3C3);
    const Color textGrayColor = Color(0xFF6D6D6D);

    final lists = context.watch<ListProvider>().lists;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ligne du haut avec le bouton retour et le titre
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton Retour
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Retour",
                          style: TextStyle(
                            color: textGrayColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // L'icône de profil sera gérée en FloatingActionButton, donc rien ici.
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Nom de la famille et image
                  Text(
                    "Listes de courses de ${familyName}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image de la famille (CircleAvatar)
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: cardColor,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/famille.png', // Chemin vers une image de famille 
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  ...lists
                  .map((list) => Column(
                        children: [
                          FamilyButton(
                            label: list.name,
                            backgroundColor: cardColor,
                            textColor: textGrayColor,
                            targetPage: GroceryList(listname: list.name),
                          ),
                          const SizedBox(height: 20), // Espacement entre chaque famille
                        ],
                      ))
                  .toList(),

              // Bouton pour ajouter une famille
              ListAddButton(
                backgroundColor: cardColor,
                textColor: textGrayColor,
              ),

                 
                ],
              ),
            ),

            // Bouton profil en haut à droite
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FloatingActionButton(
                  backgroundColor: cardColor,
                  onPressed: () {
                    // Action du bouton profil
                  },
                  child: const Icon(Icons.account_circle, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
