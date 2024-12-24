import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';

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
              backgroundColor: backgroundColor,
              title: Text('Créer une famille', style: TextStyle(color: textColor)),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Nom de la famille',
                  hintStyle: TextStyle(color: textColor),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: backgroundColor,
                  ),
                  child: Text('Annuler', style: TextStyle(color: textColor)),
                ),
                TextButton(
                  onPressed: () async {
                    final familyName = controller.text.trim();
                    if (familyName.isNotEmpty) {
                      await context.read<FamilyProvider>().addFamilyToSupabase(familyName);
                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: backgroundColor,
                  ),
                  child: Text('Ajouter', style: TextStyle(color: textColor)),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      child: Text('Ajouter une famille', style: TextStyle(color: textColor)),
    );
  }
}
