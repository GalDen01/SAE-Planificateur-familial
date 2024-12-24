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
    // data sera une List<dynamic> si on SELECT plusieurs lignes
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


  /// Insère une nouvelle famille dans la table `families` de Supabase
  Future<void> addFamilyToSupabase(String familyName) async {
  final supabase = Supabase.instance.client;

  try {
    // 1) Insertion -> récupère la Map de la famille insérée
    final data = await supabase
        .from('families')
        .insert({'name': familyName})
        .select()
        .single();

    // data est désormais un Map représentant la ligne insérée
    // Exemple: {"id": 42, "name": "Famille X", "created_at": ...}

    // 2) Convertir en objet Family
    final newFamily = Family(
      id: data['id'] as int,
      name: data['name'] as String,
    );

    // 3) Mise à jour de ta liste locale
    _families.add(newFamily);
    notifyListeners();

  } catch (e) {
    // Si une erreur survient (ex. row-level security, violation)
    debugPrint("Erreur lors de l'ajout de la famille: $e");
  }
}

}
