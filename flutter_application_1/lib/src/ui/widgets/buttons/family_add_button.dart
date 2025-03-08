import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/validated_text_field.dart'; // Import du widget

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
        final TextEditingController controller = TextEditingController();
        final GlobalKey<ValidatedTextFieldState> fieldKey = GlobalKey();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              title: Text('Créer une famille', style: TextStyle(color: textColor)),
              content: ValidatedTextField(
                key: fieldKey,
                hintText: 'Nom de la famille',
                hintTextColor: textColor,
                textColor: textColor,
                controller: controller,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Veuillez entrer un nom de famille'; 
                  }
                  return null;
                },
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
                    fieldKey.currentState?.validate();
                    if (controller.text.trim().isNotEmpty) {
                      final userEmail = context.read<AuthProvider>().currentUser?.email;
                      await context.read<FamilyProvider>().addFamilyToSupabase(
                        controller.text.trim(),
                        userEmail,
                      );
                      
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
      child: Text('Créer une famille', style: TextStyle(color: textColor)),
    );
  }
}
