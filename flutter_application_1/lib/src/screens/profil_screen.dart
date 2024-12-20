import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ProfileScreen(
      {super.key,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: grayColor,
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
                  color: grayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // L'icône de profil sera gérée en FloatingActionButton, donc rien ici.
          ],
        ),
      ),
      body: Container(
        color: grayColor,
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
