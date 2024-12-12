import 'package:flutter/material.dart';

class FamilyAddButton extends StatelessWidget {
    final Color backgroundColor;
    final Color textColor;

    const FamilyAddButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
});
    @override
    Widget build(BuildContext context){
    
    return ElevatedButton(
      onPressed: () {
        // Action que vous voulez effectuer lorsque le bouton est pressé.
        print("Ajouter une famille");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Couleur du bouton
        foregroundColor: textColor, // Couleur du texte du bouton
      ),
      child: const Text('Ajouter une famille'),
    );
  }
}