import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  final String listName;

  const ToDoList(
      {super.key,
      required this.listName,
      });

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
void confirmDeleteAllTasks() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer toutes les tâches ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              deleteAllTasks(); // Supprimer toutes les tâches
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text('Supprimer'),
          ),
        ],
      );
    },
  );
}
void deleteAllTasks() {
  setState(() {
    tasks.clear();
  });
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
    const Color backgroundGrayColor = Color(0xFF6D6D6D);
    const Color textColor = Color(0xFF6D6D6D);
    const Color backgroundColor = Color(0xFFF2C3C3);
    const Color brightCardColor = Color(0xFFF0E5D6);
    return Scaffold(
      backgroundColor: backgroundGrayColor,
      appBar: AppBar(
        backgroundColor: backgroundGrayColor,
        title: Text(widget.listName,
            style: TextStyle(color: brightCardColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed:confirmDeleteAllTasks
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Nouvelle tâche',
                filled: true, // Active la couleur de fond
                fillColor: backgroundColor, // Définir la couleur de fond
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: TextButton.styleFrom(
                foregroundColor: textColor, // Change la couleur du texte
                backgroundColor: backgroundColor, // Change la couleur de fond du bouton
              ),
              child: Text('Ajouter', style: TextStyle(color: textColor)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      // Appliquer un fond différent selon si la tâche est cochée ou non
                      color: tasks[index]['isChecked']
                          ? Colors.grey[300] // Fond gris pour les tâches terminées
                          : backgroundColor, // Utilise la couleur définie pour les tâches non terminées
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
                                  color:textColor, // Couleur du texte
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
