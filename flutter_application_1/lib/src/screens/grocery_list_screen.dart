import 'package:flutter/material.dart';

class GroceryList extends StatefulWidget {
  final String listName; // ex: "Famille #3"
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryList(
      {super.key,
      required this.listName,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});

  @override
  _GroceryListState createState() => _GroceryListState(listName: listName, cardColor: cardColor, grayColor: grayColor, brightCardColor: brightCardColor);
}

class _GroceryListState extends State<GroceryList> {
  final String listName; // ex: "Famille #3"
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  _GroceryListState(
      {
      required this.listName,
      required this.cardColor,
      required this.grayColor,
      required this.brightCardColor});
  // Liste des articles avec un compteur pour chaque article
  List<Map<String, dynamic>> articles = [];
  final TextEditingController articleController = TextEditingController();
  bool isError = false; // Indique si le champ est vide

  // Ajouter un article ou incrémenter son compteur
  void addTask() {
    if (articleController.text.isNotEmpty) {
      setState(() {
        isError = false; // Réinitialiser l'état d'erreur si le champ est rempli

        // Chercher si l'article existe déjà dans la liste
        int existingIndex = articles.indexWhere(
            (article) => article['title'].toLowerCase() == articleController.text.toLowerCase());
        
        if (existingIndex != -1) {
          // Incrémenter le compteur si l'article existe
          articles[existingIndex]['count'] += 1;
        } else {
          // Ajouter un nouvel article avec un compteur initial à 1
          articles.add({
            'title': articleController.text,
            'count': 1,
          });
        }
        articleController.clear();
      });
    } else {
      // Si le champ est vide, activer l'état d'erreur
      setState(() {
        isError = true;
      });
    }
  }

  // Afficher une boîte de dialogue pour confirmer la suppression de tous les articles
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

  // Supprimer tous les articles
  void deleteAllTasks() {
    setState(() {
      articles.clear();
    });
  }

  // Supprimer un article
  void deleteTask(int index) {
    setState(() {
      articles.removeAt(index);
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
                Navigator.pop(context); // Action du bouton Retour (retourner à l'écran précédent)
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
              controller: articleController,
              decoration: InputDecoration(
                labelText: isError ? 'Le champ ne peut pas être vide' : 'Nouvel article',
                labelStyle: TextStyle(
                  color: isError ? Colors.red : grayColor, // Texte du label en rouge si erreur
                ),
                filled: true, // Active la couleur de fond
                fillColor: isError ? Colors.red.shade100 : cardColor, // Fond rouge si erreur
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.transparent,
                  ),
                ),
              ),
              style: TextStyle(color: grayColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: TextButton.styleFrom(
                foregroundColor: grayColor, // Change la couleur du texte
                backgroundColor: cardColor, // Change la couleur de fond du bouton
              ),
              child: Text('Ajouter', style: TextStyle(color: grayColor)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: cardColor, // Utilise la couleur définie pour les tâches non terminées
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${articles[index]['title']} (x${articles[index]['count']})",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: grayColor, // Couleur du texte
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
