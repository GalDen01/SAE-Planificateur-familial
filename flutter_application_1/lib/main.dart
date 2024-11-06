import 'package:flutter/material.dart';
import 'src/screens/liste_courses.dart';
import 'src/screens/menu_principal.dart';
void main() {
  runApp(PlanificateurFamilialApp());
}

class PlanificateurFamilialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planificateur Familial',
      home: MenuPrincipal(),
    );
  }
}

