import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';

class TodoListAddButton extends StatelessWidget {
  final Color cardColor;
  final Color grayColor;

  const TodoListAddButton({
    super.key,
    required this.cardColor,
    required this.grayColor,
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
              backgroundColor: cardColor,
              title: Text('Créer une liste', style: TextStyle(color: grayColor)),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Nom de la liste',
                  hintStyle: TextStyle(color: grayColor),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: grayColor,
                    backgroundColor: cardColor,
                  ),
                  child: Text('Annuler', style: TextStyle(color: grayColor)),
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
                    foregroundColor: grayColor,
                    backgroundColor: cardColor,
                  ),
                  child: Text('Ajouter', style: TextStyle(color: grayColor)),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        foregroundColor: grayColor,
      ),
      child: Text('Ajouter une liste', style: TextStyle(color: grayColor)),
    );
  }
}
