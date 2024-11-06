// lib/screens/ajout_produit.dart
import 'package:flutter/material.dart';
import '../models/produit.dart';

class AjoutProduit extends StatefulWidget {
  @override
  _AjoutProduitState createState() => _AjoutProduitState();
}

class _AjoutProduitState extends State<AjoutProduit> {
  final _formKey = GlobalKey<FormState>();
  String nomProduit = '';

  void _sauvegarderProduit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, Produit(nom: nomProduit));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Produit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du produit'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom de produit';
                  }
                  return null;
                },
                onSaved: (value) {
                  nomProduit = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sauvegarderProduit,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
