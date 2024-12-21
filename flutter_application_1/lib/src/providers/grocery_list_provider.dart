import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';

class ListProvider extends ChangeNotifier {
  final List<GroceryListModel> _lists = [];

  List<GroceryListModel> get lists => _lists;

  void addList(String name) {
    _lists.add(GroceryListModel(name: name));
    notifyListeners();
  }
}
