import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  /// Charge toutes les familles depuis la table `families` de Supabase
  Future<void> loadFamiliesFromSupabase() async {
  final supabase = Supabase.instance.client;

  try {
    final data = await supabase
        .from('families')
        .select('*');

    // On vide la liste locale
    _families.clear();

    // data est un List, on itère
    for (final item in data) {
      _families.add(
        Family(
          id: item['id'] as int,
          name: item['name'] as String,
        ),
      );
    }

    notifyListeners();

  } catch (e) {
    debugPrint("Erreur lors du chargement des familles: $e");
  }
}

Future<void> addMemberToFamily(int familyId, String userEmail) async {
  final supabase = Supabase.instance.client;
  try {
    await supabase
        .from('family_members')
        .insert({
          'family_id': familyId,
          'user_email': userEmail,
        });
    // Optionnel: recharger la liste des membres
  } catch (e) {
    debugPrint("Erreur addMemberToFamily: $e");
  }
}


Future<void> addFamilyToSupabase(String familyName, String? userEmail) async {
  final supabase = Supabase.instance.client;

  try {
    // 1) Insert dans families
    final data = await supabase
        .from('families')
        .insert({'name': familyName})
        .select()
        .single();

    final newFamilyId = data['id'] as int;
    final newFamilyName = data['name'] as String;

    // 2) Création d'un objet local
    final newFamily = Family(id: newFamilyId, name: newFamilyName);
    _families.add(newFamily);
    notifyListeners();

    // 3) Insert dans family_members si userEmail != null
    if (userEmail != null) {
      await supabase.from('family_members').insert({
        'family_id': newFamilyId,
        'user_email': userEmail,
      });
    }
  } catch (e) {
    debugPrint("Erreur addFamilyToSupabase: $e");
  }
}

}
