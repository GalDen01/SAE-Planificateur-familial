import 'package:Planificateur_Familial/src/screens/grocery_lists_screen.dart';
import 'package:Planificateur_Familial/src/screens/todo_lists_screen.dart';
import 'package:Planificateur_Familial/src/widgets/family_button.dart';
import 'package:flutter/material.dart';
import '../screens/profil_screen.dart';

class FamilyDetailsScreen extends StatelessWidget {
  final String familyName; // ex: "Famille #3"
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const FamilyDetailsScreen(
      {super.key,
      required this.familyName,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: this.grayColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Retour",
                          style: TextStyle(
                            color: grayColor,
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
                    familyName,
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

                  // Liste des options
                  FamilyButton(
                    label: "Listes de courses",
                    backgroundColor: cardColor,
                    textColor: grayColor,
                    targetPage: GroceryLists(
                          familyName: familyName,
                          grayColor: grayColor,
                          cardColor: cardColor,
                          brightCardColor: brightCardColor,),
                  ),
                  const SizedBox(height: 10),
                  /*
                  const FamilyButton(
                    label: "Calendrier",
                    backgroundColor: cardColor,
                    textColor: textGrayColor,
                    //targetPage: const Calendrier(familyName: "Famille #3"),
                  ),
                  const SizedBox(height: 10),

                  const FamilyButton(
                    label: "Localisation",
                    backgroundColor: cardColor,
                    textColor: textGrayColor,
                    //targetPage: const Localisation(familyName: "Famille #3"),
                  ),
                  const SizedBox(height: 10),

                  const FamilyButton(
                    label: "Messagerie",
                    backgroundColor: cardColor,
                    textColor: textGrayColor,
                    //targetPage: const Messagerie(familyName: "Famille #3"),
                  ),
                  const SizedBox(height: 10),*/

                  FamilyButton(
                    label: "Tâches a faire",
                    backgroundColor: cardColor,
                    textColor: grayColor,
                    targetPage: TodoLists(
                        familyName: familyName,
                        cardColor: cardColor,
                        grayColor: grayColor,
                        brightCardColor: brightCardColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  // Bouton "Gérer famille" un peu différent (par exemple plus clair)
                  /*    const FamilyButton(
                    label: "Gérer famille",
                    backgroundColor: cardColor,
                    textColor: textGrayColor,
                    //targetPage: const GererFamille(familyName: "Famille #3"),
                  ),
                  const SizedBox(height: 10),
                  // Bouton "Quitter la famille"
                  const FamilyButton(
                    label: "Quitter la famille",
                    backgroundColor: cardColor,
                    textColor: textGrayColor,
                    //targetPage: const QuitterFamille(familyName: "Famille #3"),
                  ),*/
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(
                              brightCardColor: brightCardColor,
                              cardColor: cardColor,
                              grayColor: grayColor,)
                      ),
                    );
                  },
                  child:
                      const Icon(Icons.account_circle, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
