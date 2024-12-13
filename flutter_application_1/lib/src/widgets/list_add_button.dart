import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListAddButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  const ListAddButton({
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
              title: const Text('Ajouter une liste de course'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Nom de la liste',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    final listname = controller.text.trim();
                    if (listname.isNotEmpty) {
                      context.read<ListProvider>().addList(listname);
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
      child: const Text('Ajouter une liste'),
    );
  }
}
