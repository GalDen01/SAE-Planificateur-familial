import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Color backgroundColor;

  const ProfileScreen({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: backgroundColor, // Couleur de la barre d'applications
      ),
      body: Container(
        color: backgroundColor, // Couleur de fond du corps
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Mon Profil"),
            ],
          ),
        ),
      ),
    );
  }
}
