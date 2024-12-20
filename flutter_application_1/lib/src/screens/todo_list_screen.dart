import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  final String listName; // ex: "Famille #3"
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ToDoList(
      {super.key,
      required this.listName,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});

  @override
  _ToDoListState createState() => _ToDoListState(listName: listName, cardColor: cardColor, grayColor: grayColor, brightCardColor: brightCardColor);
}

class _ToDoListState extends State<ToDoList> {
  final String listName; // ex: "Famille #3"
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  _ToDoListState(
      {
      required this.listName,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});
  // Liste des tâches avec un état de case à cocher (isChecked)
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  // Texte et couleur du label du champ de texte
  String labelText = "Nouvelle tâche";
  Color labelTextColor = Colors.black;

  // Ajouter une nouvelle tâche
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({
          'title': taskController.text,
          'isChecked': false,
        });
        taskController.clear();
        // Réinitialiser le label à l'état normal
        labelText = "Nouvelle tâche";
        labelTextColor = Colors.black;
        sortTasks(); // Trier après ajout
      });
    } else {
      // Si le champ est vide, mettre à jour le label pour signaler l'erreur
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
          content: const Text('Êtes-vous sûr de vouloir supprimer tous les articles ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                deleteAllTasks(); // Supprimer tous les articles
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  // Trier les tâches par leur état (non cochées en premier)
  void sortTasks() {
    tasks.sort((a, b) {
      if (a['isChecked'] && !b['isChecked']) {
        return 1; // Les tâches cochées vont après les non cochées
      } else if (!a['isChecked'] && b['isChecked']) {
        return -1; // Les tâches non cochées restent avant
      }
      return 0; // Garder l'ordre si les deux sont identiques
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: grayColor,
      appBar: AppBar(
        backgroundColor: grayColor,
        automaticallyImplyLeading: false, // Désactive la flèche de retour par défaut
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Retour
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onPressed: () {
                Navigator.pop(context); // Action pour retourner à l'écran précédent
              },
              child: Text(
                "Retour",
                style: TextStyle(
                  color: grayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: labelText, // Texte dynamique
                labelStyle: TextStyle(color: labelTextColor), // Couleur dynamique
                filled: true,
                fillColor: grayColor,
                border: const OutlineInputBorder(),
              ),
              style: TextStyle(color: grayColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: TextButton.styleFrom(
                foregroundColor: grayColor,
                backgroundColor: const Color(0xFFF2C3C3),
              ),
              child: Text('Ajouter', style: TextStyle(color: grayColor)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: tasks[index]['isChecked']
                          ? Colors.grey[300]
                          : const Color(0xFFF2C3C3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: tasks[index]['isChecked'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    tasks[index]['isChecked'] = !tasks[index]['isChecked'];
                                    sortTasks();
                                  });
                                },
                              ),
                              Text(
                                tasks[index]['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: tasks[index]['isChecked']
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: grayColor,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  tasks.removeAt(index);
                                });
                              },
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
