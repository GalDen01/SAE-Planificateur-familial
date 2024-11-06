// lib/screens/menu_principal.dart
import 'package:flutter/material.dart';
import 'liste_courses.dart';

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planificateur Familial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Liste de Courses'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeCourses()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Autre Fonctionnalité (À venir)'),
              onPressed: () {
                // Ici, vous pourrez ajouter la navigation vers une nouvelle fonctionnalité
              },
            ),
          ],
        ),
      ),
    );
  }
}
