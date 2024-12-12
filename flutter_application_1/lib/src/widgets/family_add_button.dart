import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_provider.dart';

class FamilyAddButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  const FamilyAddButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final TextEditingController controller = TextEditingController();
            return AlertDialog(
              title: const Text('Créer une famille'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Nom de la famille',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final familyName = controller.text.trim();
                    if (familyName.isNotEmpty) {
                      context.read<FamilyProvider>().addFamily(familyName);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Couleur du bouton
        foregroundColor: textColor,      // Couleur du texte du bouton
      ),
      child: const Text('Ajouter une famille'),
    );
  }
}
