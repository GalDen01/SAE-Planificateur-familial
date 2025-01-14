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
  int? _userId;

  @override
  void initState() {
    super.initState();
    // 1) Charger familles pour l'utilisateur
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail != null) {
      context.read<FamilyProvider>().loadFamiliesForUser(userEmail);
    }

    // 2) Charger la météo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeather();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On rafraîchit la liste des familles à chaque fois
    final userEmail = context.read<AuthProvider>().currentUser?.email;
    if (userEmail != null) {
      context.read<FamilyProvider>().loadFamiliesForUser(userEmail);
      _fetchUserIdAndPendingInvs(userEmail);
    }
  }

  /// Récupère userId + pendingInvCount
  Future<void> _fetchUserIdAndPendingInvs(String userEmail) async {
    final supabase = Supabase.instance.client;
    final userRes = await supabase
        .from('users')
        .select('id')
        .eq('email', userEmail)
        .maybeSingle();

    if (userRes != null && userRes['id'] != null) {
      final userId = userRes['id'] as int;
      setState(() {
        _userId = userId;
      });
      await context.read<FamilyProvider>().loadPendingInvitationsCount(userId);
    }
  }

  /// Ouvre l'écran des invitations, si userId dispo
  Future<void> _goToInvitations() async {
    if (_userId == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvitationsScreen(userId: _userId!),
      ),
    );
  }

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
    final familyProvider = context.watch<FamilyProvider>();
    final families = familyProvider.families;
    final pendingInvCount = familyProvider.pendingInvCount;

    // S’il y a une invitation => on met un icône “unread”, sinon “read”
    final invitationsIcon = (pendingInvCount > 0)
        ? Icons.mark_email_unread
        : Icons.mark_email_read;

    return Scaffold(
      backgroundColor: AppColors.grayColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Première rangée : "Menu principal" + icônes
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
                      // Bouton INVITATIONS
                      FloatingActionButton(
                        heroTag: "invitBtn",
                        backgroundColor: AppColors.brightCardColor,
                        onPressed: _goToInvitations,
                        child: Icon(invitationsIcon),
                      ),
                      const SizedBox(width: 10),
                      // Bouton PROFIL
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

              // Météo
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
