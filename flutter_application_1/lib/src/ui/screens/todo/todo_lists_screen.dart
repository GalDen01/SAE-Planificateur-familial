// lib/src/ui/screens/todo/todo_lists_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/models/todo_list.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_list_screen.dart';

class TodoListsScreen extends StatefulWidget {
  final int familyId;
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const TodoListsScreen({
    super.key,
    required this.familyId,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<TodoListsScreen> createState() => _TodoListsScreenState();
}

class _TodoListsScreenState extends State<TodoListsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoListProvider>().loadListsForFamily(widget.familyId);
  }

  Future<void> _createListDialog() async {
    final controller = TextEditingController();
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: widget.cardColor,
          title: Text('Créer une liste', style: TextStyle(color: widget.grayColor)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Nom de la liste',
              hintStyle: TextStyle(color: widget.grayColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
              ),
              child: Text('Annuler', style: TextStyle(color: widget.grayColor)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
              ),
              child: Text('Ajouter', style: TextStyle(color: widget.grayColor)),
            ),
          ],
        );
      },
    );

    if (res != null && res.isNotEmpty) {
      await context.read<TodoListProvider>().createList(widget.familyId, res);
      setState(() {}); // rafraîchir
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoListProvider>();
    final lists = provider.lists;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: SafeArea(
        
        child: SingleChildScrollView(
          
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "To-do listes de ${widget.familyName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.brightCardColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Icon
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: widget.cardColor,
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        'assets/images/todo_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton "Créer une liste"
                ElevatedButton(
                  onPressed: _createListDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.cardColor,
                    foregroundColor: widget.grayColor,
                  ),
                  child: const Text("Créer une liste"),
                ),
                const SizedBox(height: 30),

                // Listes existantes
                ...lists.map((TodoListModel list) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: widget.cardColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        list.name,
                        style: TextStyle(
                          color: widget.grayColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Naviguer vers l'écran des tâches
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ToDoListScreen(
                              listId: list.id!,
                              listName: list.name,
                              cardColor: widget.cardColor,
                              grayColor: widget.grayColor,
                              brightCardColor: widget.brightCardColor,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppColors.deletColor,
                        onPressed: () async {
                          // Supprimer la liste
                          await provider.deleteList(list.id!);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
