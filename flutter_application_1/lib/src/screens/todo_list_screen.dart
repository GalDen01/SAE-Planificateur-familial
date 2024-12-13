import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  final String familyName;

  const ToDoList({super.key, required this.familyName});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Liste des tâches avec un état de case à cocher (isChecked)
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  // Ajouter une nouvelle tâche
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({
          'title': taskController.text,
          'isChecked': false,
        });
        taskController.clear();
      });
    }
  }

  // Supprimer une tâche
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Modifier l'état de la tâche (cocher ou décocher)
  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['isChecked'] = !tasks[index]['isChecked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List de ${widget.familyName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                tasks.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Nouvelle tâche',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              child: const Text('Ajouter'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            // Checkbox pour marquer la tâche comme terminée
                            Checkbox(
                              value: tasks[index]['isChecked'],
                              onChanged: (bool? value) {
                                toggleTaskCompletion(index);
                              },
                            ),
                            // Titre de la tâche avec une barre de traversée si elle est terminée
                            Text(
                              tasks[index]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                decoration: tasks[index]['isChecked']
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(index),
                          ),
                        ),
                      ],
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
