import 'package:flutter/material.dart';
import '../models/family.dart';

class FamilyProvider with ChangeNotifier {
  final List<Family> _families = [];

  List<Family> get families => List.unmodifiable(_families);

  void addFamily(String name) {
    _families.add(Family(name: name));
    notifyListeners();
  }
}
