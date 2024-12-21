import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];

  List<Family> get families => _families;

  void addFamily(String name) {
    _families.add(Family(name: name));
    notifyListeners();
  }
}
