import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/profile/profile_screen.dart';

class BackProfileBar extends StatelessWidget implements PreferredSizeWidget {
  ///action à effectuer quand on appuie sur le bouton Retour
  final VoidCallback onBack;

  ///action à effectuer quand on appuie sur le bouton Profil
  final VoidCallback? onProfile;

  const BackProfileBar({
    super.key,
    required this.onBack,
    this.onProfile,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // On garde le fond "transparent"
      elevation: 0,
      automaticallyImplyLeading: false,  // pour personnalisé le bouton retour
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Bouton RETOUR ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCardColor, // Couleur demandée
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
                onPressed: onBack,
                child: Text(
                  "Retour",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // --- Bouton PROFIL ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCardColor, // Couleur demandée
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
                onPressed: onProfile ??
                    () {
                      // Action par défaut si onProfile n'est pas fourni :
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(
                            // Met ici les couleurs que tu veux passer
                            cardColor: AppColors.cardColor,
                            grayColor: AppColors.grayColor,
                            brightCardColor: AppColors.brightCardColor,
                          ),
                        ),
                      );
                    },
                child: const Icon(Icons.account_circle, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
