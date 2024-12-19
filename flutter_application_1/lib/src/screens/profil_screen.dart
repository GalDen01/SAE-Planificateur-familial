import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Color backgroundColor;

  const ProfileScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFF2C3C3); // Définir une couleur pour le bouton Retour
    const Color textGrayColor = Color(0xFF6D6D6D); // Définir une couleur pour le texte du bouton

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false, // Désactiver la flèche de retour par défaut
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Retour
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onPressed: () {
                Navigator.pop(context); // Action du bouton Retour (retourner à l'écran précédent)
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
      ),
      body: Container(
        color: backgroundColor,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Mon Profil"),
            ],
          ),
        ),
      ),
    );
  }
}
