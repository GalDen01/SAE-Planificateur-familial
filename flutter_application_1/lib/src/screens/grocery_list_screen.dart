import 'package:flutter/material.dart';

class GroceryList extends StatefulWidget {
  final String listName;
  

  const GroceryList(
      {super.key,
      required this.listName,
      });

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // Liste des tâches avec un état de case à cocher (isChecked)
  List<Map<String, dynamic>> articles = [];
  final TextEditingController articleController = TextEditingController();

  // Ajouter une nouvelle tâche
  void addTask() {
    if (articleController.text.isNotEmpty) {
      setState(() {
        articles.add({
          'title': articleController.text,
        });
        articleController.clear();
      });
    }
  }

  // Supprimer une tâche
  void deleteTask(int index) {
    setState(() {
      articles.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF6D6D6D);
    const Color textColor = Color(0xFF6D6D6D);
    const Color cardColor = Color(0xFFF2C3C3);
    const Color brightCardColor = Color(0xFFF0E5D6);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.listName,
            style: TextStyle(color: brightCardColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                articles.clear();
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
              controller: articleController,
              decoration: InputDecoration(
                labelText: 'Nouvel article',
                filled: true, // Active la couleur de fond
                fillColor: cardColor, // Définir la couleur de fond
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: TextButton.styleFrom(
                foregroundColor: textColor, // Change la couleur du texte
                backgroundColor: cardColor, // Change la couleur de fond du bouton
              ),
              child: Text('Ajouter', style: TextStyle(color: textColor)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      // Appliquer un fond différent selon si la tâche est cochée ou non
                      color: cardColor, // Utilise la couleur définie pour les tâches non terminées
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(                          
                            children: [
                              // Titre de la tâche avec une barre de traversée si elle est terminée
                              Text(
                                articles[index]['title'],
                                style: const TextStyle(
                                  fontSize: 18,                                  
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
