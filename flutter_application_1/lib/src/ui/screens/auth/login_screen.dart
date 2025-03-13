import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/auth/cgu_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hasAcceptedCGU = false;

  Future<void> _showCguDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => const CguDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.grayColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre principal
                Text(
                  "La coordination familiale,\nréinventée",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 30),

                // IMAGE (au milieu)
                SizedBox(
                  height: 180,
                  child: Image.asset(
                    "assets/images/login_page_family.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  "FamLink vous aide à collaborer facilement :\n"
                  "des calendriers synchronisés, des listes interactives\n"
                  "et une localisation sécurisée pour rester en contact.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 40),

                // Checkbox CGU
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _hasAcceptedCGU,
                      onChanged: (val) {
                        setState(() {
                          _hasAcceptedCGU = val ?? false;
                        });
                      },
                      activeColor: AppColors.cardColor,
                      checkColor: AppColors.blackColor,
                    ),
                    GestureDetector(
                      onTap: _showCguDialog,
                      child: Text(
                        "J'accepte les Conditions Générales d'Utilisation",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Bouton "SE CONNECTER VIA GOOGLE"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      //si pas accepté alorson arrête tout de suite
                      if (!_hasAcceptedCGU) {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Vous devez accepter les CGU pour continuer.",
                            ),
                          ),
                        );
                        return;
                      }

                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      await authProvider.signInWithGoogle();

                      if (!mounted) return;

                      if (authProvider.isLoggedIn) {
                        navigator.pushReplacementNamed('/home');
                      } else {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text("Échec de la connexion."),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasAcceptedCGU
                          ? AppColors.cardColor
                          : AppColors.lightGray,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "SE CONNECTER VIA GOOGLE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _hasAcceptedCGU
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
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
