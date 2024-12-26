import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/header_menu.dart';
import 'package:Planificateur_Familial/src/ui/widgets/weather_card.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_add_button.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/family_details_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/profile/profile_screen.dart';
import 'package:Planificateur_Familial/src/models/family.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail != null) {
      context.read<FamilyProvider>().loadFamiliesForUser(userEmail);
    }
  }


  @override
  Widget build(BuildContext context) {
    final families = context.watch<FamilyProvider>().families;

    return Scaffold(
      backgroundColor: AppColors.grayColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderMenu(
                title: "Menu principal",
                textColor: AppColors.brightCardColor,
                fontSize: 32,
              ),
              const SizedBox(height: 30),

              const WeatherCard(
                backgroundColor: AppColors.cardColor,
                cityName: "Limoges",
                temperature: "12°C",
                weatherLabel: "Pluie",
                weatherIcon: Icons.cloud,
                temperatureIcon: Icons.thermostat,
                homeIcon: Icons.home,
                textColor: AppColors.blackColor,
              ),

              const SizedBox(height: 50),

              // Liste des familles
              ...families.map((Family family) {
                return Column(
                  children: [
                    FamilyButton(
                      label: family.name,
                      backgroundColor: AppColors.cardColor,
                      textColor: AppColors.grayColor,
                      targetPage: FamilyDetailsScreen(
                        familyId: family.id!,
                        familyName: family.name,
                        cardColor: AppColors.cardColor,
                        grayColor: AppColors.grayColor,
                        brightCardColor: AppColors.brightCardColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),

              // Bouton pour ajouter une famille
              const FamilyAddButton(
                backgroundColor: AppColors.cardColor,
                textColor: AppColors.grayColor,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FloatingActionButton(
          backgroundColor: AppColors.brightCardColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(
                  cardColor: AppColors.cardColor,
                  grayColor: AppColors.grayColor,
                  brightCardColor: AppColors.brightCardColor,
                ),
              ),
            );
          },
          child: const Icon(Icons.account_circle, color: Colors.black87),
        ),
      ),
    );
  }
}
