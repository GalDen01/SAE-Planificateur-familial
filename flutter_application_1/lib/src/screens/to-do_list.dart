import 'package:flutter/material.dart';

class ToDoList extends StatelessWidget {
  final String familyName; // ex: "Famille #3"

  const ToDoList({super.key, required this.familyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de tâches de la famille $familyName'),
      ),
      body: Center(
        child: Text('Liste de tâches de la famille $familyName'),
      ),
    );
  }
}
