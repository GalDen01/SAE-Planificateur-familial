import 'package:flutter/material.dart';

class GroceryListScreen extends StatefulWidget {
  final String listName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryListScreen({
    super.key,
    required this.listName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<Map<String, dynamic>> articles = [];
  final TextEditingController articleController = TextEditingController();
  bool isError = false;

  void addTask() {
    if (articleController.text.isNotEmpty) {
      setState(() {
        isError = false;
        final existingIndex = articles.indexWhere(
          (article) =>
              article['title'].toLowerCase() == articleController.text.toLowerCase(),
        );
        if (existingIndex != -1) {
          articles[existingIndex]['count'] += 1;
        } else {
          articles.add({
            'title': articleController.text,
            'count': 1,
          });
        }
        articleController.clear();
      });
    } else {
      setState(() {
        isError = true;
      });
    }
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

  void deleteAllTasks() {
    setState(() {
      articles.clear();
    });
  }

  void deleteTask(int index) {
    setState(() {
      articles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.grayColor,
      appBar: AppBar(
        backgroundColor: widget.grayColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Retour",
                style: TextStyle(
                  color: widget.grayColor,
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
                  color: isError ? Colors.red : widget.grayColor,
                ),
                filled: true,
                fillColor: isError ? Colors.red.shade100 : widget.cardColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.transparent,
                  ),
                ),
              ),
              style: TextStyle(color: widget.grayColor),
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
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: widget.cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${articles[index]['title']} (x${articles[index]['count']})",
                            style: TextStyle(
                              fontSize: 18,
                              color: widget.grayColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteTask(index),
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
