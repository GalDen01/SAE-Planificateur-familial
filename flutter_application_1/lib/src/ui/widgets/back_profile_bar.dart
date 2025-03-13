import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/profile/profile_screen.dart';

class BackProfileBar extends StatelessWidget implements PreferredSizeWidget {
  ///quand on appuie sur "Retour".
  final VoidCallback onBack;

  ///quand on appuie sur "Profil". Par défaut, ouvre [ProfileScreen].
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton RETOUR
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                onPressed: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.blackColor,
                ),
              ),

              // Bouton PROFIL
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                ),
                onPressed: onProfile ??
                    () {
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
                child: const Icon(Icons.account_circle, color: AppColors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
