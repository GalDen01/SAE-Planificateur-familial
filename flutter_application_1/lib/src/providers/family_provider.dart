import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  //pour que certaines parties de l'app puis avoir accès à la liste sans pouvoir la modifier
  List<Family> get families => _families;

  void addFamily(String name) {
    _families.add(Family(name: name));
    notifyListeners(); //pour informer  tous les widgets qui utilise la liste qu'elle a changé
  }
}
