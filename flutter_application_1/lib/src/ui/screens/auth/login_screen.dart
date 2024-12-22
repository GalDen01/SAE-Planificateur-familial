import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.grayColor, // Arrière-plan gris
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre principal
                const Text(
                  "La coordination familiale,\nréinventée",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ou AppColors.brightCardColor
                  ),
                ),
                const SizedBox(height: 30),

                // IMAGE (au milieu)
                // Remplace 'https://...' par ton chemin asset ou un lien
                SizedBox(
                  height: 180, // ou ce que tu veux
                  child: Image.asset(
                    "assets/images/login_page_family.png", 
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),

                // Texte descriptif
                const Text(
                  "FamLink vous aide à collaborer facilement :\n"
                  "des calendriers synchronisés, des listes interactives\n"
                  "et une localisation sécurisée pour rester en contact.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton "Se connecter via Google"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await authProvider.signInWithGoogle();
                      if (authProvider.isLoggedIn) {
                        // Si la connexion réussit, tu peux naviguer vers HomeScreen
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        // Gérer l'erreur ou rester sur la page
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardColor,  // rose saumon pale
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "SE CONNECTER VIA GOOGLE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Couleur du texte
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
