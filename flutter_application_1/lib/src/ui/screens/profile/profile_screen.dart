import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.grayColor,
      appBar: AppBar(
        backgroundColor: grayColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // --- Bouton RETOUR ---
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                onPressed: () {
                Navigator.pop(context);
              },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,
                ),
              ),

            const Spacer(),

            // --- Bouton DÉCONNEXION ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brightCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
              ),
              onPressed: () async {
                await authProvider.signOut();
                
                // Réinitialise la pile de navigation et va sur la page de login :
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/login',
                  (route) => false,
                );
              },
              child: Text(
                "Déconnexion",
                style: TextStyle(
                  color: grayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Titre principal
              const Text(
                "Profil utilisateur",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 30),

              // Avatar (Photo de profil Google)
              SizedBox(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: user != null &&
                          user.photoUrl != null &&
                          user.photoUrl!.isNotEmpty
                      ? Image.network(
                          user.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) {
                            return Container(
                              color: AppColors.whiteColor.withOpacity(0.7),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 64,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.whiteColor.withOpacity(0.7),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),

              // Carte "Votre Prénom"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    "Votre Prénom : ${user?.displayName ?? 'Inconnu'}",
                    style: const TextStyle(
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Carte "Votre email"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                margin: const EdgeInsets.only(bottom: 30.0),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    "Votre email : ${user?.email ?? 'Inconnu'}",
                    style: const TextStyle(
                      color: AppColors.grayColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
