import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';
import '../widgets/header_menu.dart';
import '../widgets/weather_card.dart';
import '../widgets/family_button.dart';
import '../widgets/family_add_button.dart';
import '../screens/family_details_screen.dart';
import '../screens/profil_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFF5D5CD); // Rose saumon pâle
    const Color grayColor = Color(0xFF6D6D6D); // Gris pour le texte
    const Color brightCardColor = Color(0xFFF0E5D6);
    const Color blackColor = Color.fromARGB(255, 49, 49, 49);

    final families = context.watch<FamilyProvider>().families;

    return Scaffold( 
      backgroundColor: grayColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre "Menu principal"
              const HeaderMenu(
                title: "Menu principal",
                textColor: brightCardColor,
                fontSize: 32,
              ),
              const SizedBox(height: 30),

              // WeatherCard
              const WeatherCard(
                backgroundColor: cardColor,
                cityName: "Limoges",
                temperature: "12°C",
                weatherLabel: "Pluie",
                weatherIcon: Icons.cloud,
                temperatureIcon: Icons.thermostat,
                homeIcon: Icons.home,
                textColor: blackColor,
              ),

              const SizedBox(height: 50),

              // Liste des boutons familles avec espacement
              ...families.map((family) => Column(
                    children: [
                      FamilyButton(
                        label: family.name,
                        backgroundColor: cardColor,
                        textColor: grayColor,
                        targetPage: FamilyDetailsScreen(
                            familyName: family.name,
                            cardColor: cardColor,
                            grayColor: grayColor,
                            brightCardColor: brightCardColor),
                      ),
                      const SizedBox(
                          height: 20), // Espacement entre chaque famille
                    ],
                  )),

              // Bouton pour ajouter une famille
              const FamilyAddButton(
                backgroundColor: cardColor,
                textColor: grayColor,
              ),
            ],
          ),
        ),
      ),
      // Icône de profil en haut à droite
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          backgroundColor: brightCardColor,
          onPressed: () {
            // Action du bouton profil
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(
                                    grayColor:grayColor,
                                    cardColor: cardColor,
                                    brightCardColor: brightCardColor),
              ),
            );
          },
          child: const Icon(Icons.account_circle, color: Colors.black87),
        ),
      ),
    );
  }
}
