// lib/src/ui/screens/todo/todo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:Planificateur_Familial/src/models/todo_task.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';

class ToDoListScreen extends StatefulWidget {
  final int listId;
  final String listName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ToDoListScreen({
    super.key,
    required this.listId,
    required this.listName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final TextEditingController taskController = TextEditingController();
  List<TodoTaskModel> _allTasks = [];
  String labelText = "Nouvelle tâche";
  Color labelTextColor = AppColors.blackColor;

  bool _showOnlyUnchecked = false; // si vrai => on ne montre que tasks isChecked == false

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final provider = context.read<TodoListProvider>();
    final tasks = await provider.loadTasksForList(widget.listId);
    setState(() {
      _allTasks = tasks;
    });
  }

  List<TodoTaskModel> get filteredTasks {
    if (_showOnlyUnchecked) {
      return _allTasks.where((t) => t.isChecked == false).toList();
    }
    return _allTasks;
  }

  Future<void> addTask() async {
    final text = taskController.text.trim();
    if (text.isEmpty) {
      setState(() {
        labelText = "Veuillez entrer une tâche";
        labelTextColor = AppColors.errorColor;
      });
      return;
    }
    try {
      await context.read<TodoListProvider>().createTask(widget.listId, text);
      taskController.clear();
      labelText = "Nouvelle tâche";
      labelTextColor = AppColors.blackColor;
      await loadTasks();
    } catch (e) {
      // Gérer l'erreur, ex. affichage d'un snackbar
    }
  }

  Future<void> toggleChecked(TodoTaskModel task) async {
    await context
        .read<TodoListProvider>()
        .updateTaskChecked(task.id!, !task.isChecked);
    await loadTasks();
  }

  Future<void> deleteTask(int taskId) async {
    await context.read<TodoListProvider>().deleteTask(taskId);
    await loadTasks();
  }

  void confirmDeleteAllTasks() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Supprimer toutes les tâches ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // On supprime localement toutes les tasks
                setState(() {
                  _allTasks.clear();
                });
                Navigator.pop(ctx);
                // note: si on veut le faire en BDD => on doit faire un .delete() sur "todo_tasks" eq listId
                // ou un CASCADE sur la table
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = filteredTasks;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre de la liste
            Text(
              widget.listName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.brightCardColor,
              ),
            ),
            const SizedBox(height: 10),

            // Bouton toggle "Afficher que les non cochées"
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Filtrer par tâches",
                  style: TextStyle(color: widget.brightCardColor),
                ),
                Switch(
                  value: _showOnlyUnchecked,
                  onChanged: (val) {
                    setState(() {
                      _showOnlyUnchecked = val;
                    });
                  },
                  activeColor: widget.cardColor,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // TextField pour ajouter
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: labelTextColor),
                filled: true,
                fillColor: widget.cardColor,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.cardColor,
                foregroundColor: widget.grayColor,
              ),
              child: const Text("Ajouter"),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Text(
                        "Aucune tâche trouvée",
                        style: TextStyle(color: widget.brightCardColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (ctx, index) {
                        final task = tasks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: task.isChecked
                                ? AppColors.lightGray
                                : widget.cardColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isChecked,
                              onChanged: (_) => toggleChecked(task),
                            ),
                            title: Text(
                              task.content,
                              style: TextStyle(
                                fontSize: 16,
                                decoration: task.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: widget.grayColor,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: AppColors.errorColor,
                              onPressed: () => deleteTask(task.id!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
