import 'package:flutter/material.dart';


class ToDoList extends StatefulWidget {
  final String familyName; // Paramètre pour le nom de la famille

  // Le constructeur attend un nom de famille en paramètre
  const ToDoList({super.key, required this.familyName});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Liste de tâches
  List<String> tasks = [];

  // Contrôleur pour saisir une nouvelle tâche
  final TextEditingController taskController = TextEditingController();

  // Fonction pour ajouter une tâche
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();  // Vide le champ de texte après ajout
      });
    }
  }

  // Fonction pour supprimer une tâche
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List de ${widget.familyName}'), // Utilisation du nom de famille dans le titre
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                tasks.clear();  // Effacer toutes les tâches
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de texte pour ajouter une tâche
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
            // Liste des tâches
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteTask(index),
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
