import 'package:flutter/material.dart';
import '../models/tache.dart';
import 'ajout_taches.dart';

class ListeTaches extends StatefulWidget {
  @override
  _ListeTachesState createState() => _ListeTachesState();
}

class _ListeTachesState extends State<ListeTaches> {
  List<Tache> taches = [];

  void ajouterTache(Tache tache) {
    setState(() {
      taches.add(tache);
    });
  }

  void basculerEtatTache(int index) {
    setState(() {
      taches[index].estComplete = !taches[index].estComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do Liste'),
      ),
      body: ListView.builder(
        itemCount: taches.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              taches[index].titre,
              style: TextStyle(
                decoration: taches[index].estComplete
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            leading: Checkbox(
              value: taches[index].estComplete,
              onChanged: (bool? valeur) {
                basculerEtatTache(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultat = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjoutTache()),
          );
          if (resultat != null) {
            ajouterTache(resultat);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
