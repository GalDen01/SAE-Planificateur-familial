import 'package:Planificateur_Familial/src/models/todo_list.dart';
import 'package:flutter/material.dart';

class TodoListProvider with ChangeNotifier {
  final List<TodoList> _lists = [];

  List<TodoList> get lists => List.unmodifiable(_lists);

  void addList(String name) {
    _lists.add(TodoList(name: name));
    notifyListeners();
  }
}
