// lib/src/ui/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/providers/weather_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/header_menu.dart';
import 'package:Planificateur_Familial/src/ui/widgets/weather_card.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_add_button.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/family_details_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/profile/profile_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/family/invitations_screen.dart';

import 'package:Planificateur_Familial/src/models/family.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Appelé une seule fois au montage initial.
  @override
  void initState() {
    super.initState();
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail != null) {
      context.read<FamilyProvider>().loadFamiliesForUser(userEmail);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather();
    });
  }

  /// Appelé chaque fois que ce widget réapparaît (après un retour par ex.)
  /// pour rafraîchir la liste des familles.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail != null) {
      context.read<FamilyProvider>().loadFamiliesForUser(userEmail);
    }
  }

  /// Ouvre l'écran des invitations, si userId dispo
  Future<void> _goToInvitations() async {
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail == null) return;

    final supabase = Supabase.instance.client;
    final userRes = await supabase
        .from('users')
        .select('id')
        .eq('email', userEmail)
        .maybeSingle();

    if (userRes != null && userRes['id'] != null) {
      final userId = userRes['id'] as int;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InvitationsScreen(userId: userId),
        ),
      );
    }
  }

  /// Ouvre l'écran de profil
  void _goToProfile() {
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
              // Première rangée : "Menu principal" + icônes 
              // (invitations + profil) alignées à l'horizontal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeaderMenu(
                    title: "Menu principal",
                    textColor: AppColors.brightCardColor,
                    fontSize: 32,
                  ),
                  Row(
                    children: [
                      // Bouton pour accéder aux invitations
                      FloatingActionButton(
                        heroTag: "invitBtn", // pour éviter le clash si on a plusieurs FABs
                        backgroundColor: AppColors.brightCardColor,
                        onPressed: _goToInvitations,
                        child: const Icon(Icons.mark_email_unread),
                      ),
                      const SizedBox(width: 10),
                      // Bouton pour accéder au profil
                      FloatingActionButton(
                        heroTag: "profileBtn",
                        backgroundColor: AppColors.brightCardColor,
                        onPressed: _goToProfile,
                        child: const Icon(Icons.account_circle,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              const WeatherCard(
                backgroundColor: AppColors.cardColor,
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
    );
  }
}
