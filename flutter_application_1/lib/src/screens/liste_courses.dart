import 'package:flutter/material.dart';
import '../models/produit.dart';
import 'ajout_produit.dart';

class ListeCourses extends StatefulWidget {
  @override
  _ListeCoursesState createState() => _ListeCoursesState();
}

class _ListeCoursesState extends State<ListeCourses> {
  List<Produit> produits = [];

  void ajouterProduit(Produit produit) {
    setState(() {
      produits.add(produit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de Courses'),
      ),
      body: ListView.builder(
        itemCount: produits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produits[index].nom),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultat = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjoutProduit()),
          );
          if (resultat != null) {
            ajouterProduit(resultat);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
