// lib/src/ui/screens/todo/todo_list_screen.dart

import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class ToDoListScreen extends StatefulWidget {
  final String listName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ToDoListScreen({
    super.key,
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
  final List<Map<String, dynamic>> tasks = [];

  String labelText = "Nouvelle tâche";
  Color labelTextColor = Colors.black;

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({
          'title': taskController.text,
          'isChecked': false,
        });
        taskController.clear();
        labelText = "Nouvelle tâche";
        labelTextColor = Colors.black;
        sortTasks();
      });
    } else {
      setState(() {
        labelText = "Veuillez entrer une tâche";
        labelTextColor = Colors.red;
      });
    }
  }

  void deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
  }

  void confirmDeleteAllTasks() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer tous les articles ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                deleteAllTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void sortTasks() {
    tasks.sort((a, b) {
      if (a['isChecked'] && !b['isChecked']) {
        return 1;
      } else if (!a['isChecked'] && b['isChecked']) {
        return -1;
      }
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilisation du BackProfileBar
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: labelTextColor),
                filled: true,
                fillColor: widget.grayColor,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
              ),
              child: Text('Ajouter', style: TextStyle(color: widget.grayColor)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final isChecked = task['isChecked'] ?? false;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: isChecked ? Colors.grey[300] : widget.cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    tasks[index]['isChecked'] = !isChecked;
                                    sortTasks();
                                  });
                                },
                              ),
                              Text(
                                task['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration:
                                      isChecked ? TextDecoration.lineThrough : null,
                                  color: widget.grayColor,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                          ),
                        ],
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
