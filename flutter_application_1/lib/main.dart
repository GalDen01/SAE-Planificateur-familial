import 'package:flutter/material.dart';
import 'src/screens/menu_screen.dart';

void main() {
  runApp(const PlanningApp());
}

class PlanningApp extends StatelessWidget {
  const PlanningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planificateur Familial',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MenuScreen(),
    );
  }
}
