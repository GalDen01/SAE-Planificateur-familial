import 'package:flutter/material.dart';
import '../models/grocery_list.dart';

class ListProvider with ChangeNotifier {
  final List<GroceryList> _lists = [];

  List<GroceryList> get lists => List.unmodifiable(_lists);

  void addList(String name) {
    _lists.add(GroceryList(name: name));
    notifyListeners();
  }
}
