import 'package:flutter/material.dart';

class FamilyDetailsScreen extends StatelessWidget {
  final String familyName; // ex: "Famille #3"

  const FamilyDetailsScreen({super.key, required this.familyName});

  @override
  Widget build(BuildContext context) {
    // Les mêmes couleurs que dans le menu principal
    final Color backgroundColor = const Color(0xFF6D6D6D);
    final Color cardColor = const Color(0xFFF2C3C3);
    final Color textGrayColor = const Color(0xFF6D6D6D);

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
                  _buildFamilyOptionButton("Listes de courses", cardColor, textGrayColor),
                  const SizedBox(height: 20),
                  _buildFamilyOptionButton("Calendrier", cardColor, textGrayColor),
                  const SizedBox(height: 20),
                  _buildFamilyOptionButton("Localisation", cardColor, textGrayColor),
                  const SizedBox(height: 20),
                  _buildFamilyOptionButton("Messagerie", cardColor, textGrayColor),
                  const SizedBox(height: 20),
                  _buildFamilyOptionButton("Tâches à faire", cardColor, textGrayColor),
                  const SizedBox(height: 20),

                  // Bouton "Gérer famille" un peu différent (par exemple plus clair)
                  _buildFamilyOptionButton("Gérer famille", const Color(0xFFF3EBDD), textGrayColor),
                  const SizedBox(height: 20),

                  // Bouton "Quitter la famille"
                  _buildFamilyOptionButton("Quitter la famille", cardColor, textGrayColor),
                  const SizedBox(height: 40),
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

  Widget _buildFamilyOptionButton(String label, Color backgroundColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 3,
        ),
        onPressed: () {
          // Action spécifique à chaque option
        },
        child: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
