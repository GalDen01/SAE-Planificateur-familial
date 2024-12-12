import 'package:flutter/material.dart';
import '../widgets/header_menu.dart';
import '../screens/family_details_screen.dart';
import '../widgets/weather_card.dart';
import '../widgets/family_button.dart';
import '../widgets/family_add_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color.fromARGB(255, 104, 104, 104); // Gris foncé
    const Color cardColor = Color(0xFFF5D5CD);       // Rose saumon pâle
    const Color textGrayColor = Color(0xFF6D6D6D);   // Gris pour le texte
    const Color brightCardColor = Color(0xFFF0E5D6);  
    const Color blackColor = Color.fromARGB(255, 49, 49, 49);
    final Color salmonPink = cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre "Menu principal" plus grand et légèrement remonté
              HeaderMenu(
                title: "Menu principal",
                textColor: brightCardColor,
                fontSize: 32, // Taille du texte
              ),
              const SizedBox(height: 30), // Espacement après le titre

              // WeatherCard affichée en colonne
              WeatherCard(
                backgroundColor: cardColor,
                cityName: "Limoges",
                temperature: "12°C",
                weatherLabel: "Pluie",
                weatherIcon: Icons.cloud,
                temperatureIcon: Icons.thermostat,
                homeIcon: Icons.home,
                textColor: blackColor,
              ),

              const SizedBox(height: 50), // Espacement après la WeatherCard

              // Boutons familles
              FamilyButton(
            label: "Famille #3",
            backgroundColor: cardColor,
            textColor: textGrayColor,
            targetPage: const FamilyDetailsScreen(familyName: "Famille #3"),
          ),

              const SizedBox(height: 20), // Espacement entre les boutons
              FamilyButton(
              label: "Famille #4",
              backgroundColor: cardColor,
              textColor: textGrayColor,
              targetPage: const FamilyDetailsScreen(familyName: "Famille #4"),
            ),
              const SizedBox(height: 20),
              FamilyAddButton(
                backgroundColor: cardColor,
                textColor: textGrayColor,
              ),
            ],
          ),
        ),
      ),
      // Icône de profil (en haut à droite)
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      
      floatingActionButton: Padding(
      padding: const EdgeInsets.only(top: 10.0), // Ajout du décalage
      child: FloatingActionButton(
        backgroundColor: brightCardColor,
        onPressed: () {
          // Action du bouton profil
        },
        child: const Icon(Icons.account_circle, color: Colors.black87),
        ),
      ),
    );
  }
}
