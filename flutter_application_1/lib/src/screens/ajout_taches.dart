import 'package:flutter/material.dart';
import '../models/tache.dart';

class AjoutTache extends StatefulWidget {
  @override
  _AjoutTacheState createState() => _AjoutTacheState();
}

class _AjoutTacheState extends State<AjoutTache> {
  final _formKey = GlobalKey<FormState>();
  String titreTache = '';

  void _sauvegarderTache() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, Tache(titre: titreTache));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une Tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Titre de la tâche'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre de tâche';
                  }
                  return null;
                },
                onSaved: (value) {
                  titreTache = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sauvegarderTache,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
