import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/models/todo_list.dart';

class TodoListProvider extends ChangeNotifier {
  final List<TodoListModel> _lists = [];

  List<TodoListModel> get lists => _lists;

  void addList(String name) {
    _lists.add(TodoListModel(name: name));
    notifyListeners();
  }
}
