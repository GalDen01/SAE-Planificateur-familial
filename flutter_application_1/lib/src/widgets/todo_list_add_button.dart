import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoListAddButton
 extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  const TodoListAddButton({
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
              title: Text('Créer une liste',style: TextStyle(color: textColor)),
              content: TextField(
                controller: controller,
                decoration:  InputDecoration(
                  hintText: 'Nom de la liste',
                  hintStyle: TextStyle(color: textColor),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: textColor, // Change la couleur du texte
                    backgroundColor: backgroundColor, // Change la couleur de fond du bouton
                  ),
                  child: Text('Annuler', style: TextStyle(color: textColor)),
                ),
                TextButton(
                  onPressed: () {
                    final listname = controller.text.trim();
                    if (listname.isNotEmpty) {
                      context.read<TodoListProvider>().addList(listname);
                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: textColor, // Change la couleur du texte
                    backgroundColor: backgroundColor, // Change la couleur de fond du bouton
                  ),
                  child: Text('Ajouter', style: TextStyle(color: textColor)),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Couleur du bouton
        foregroundColor: textColor, // Couleur du texte du bouton
      ),
      child: Text('Ajouter une liste', style: TextStyle(color: textColor)),
    );
  }
}
