import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  /// Charge toutes les familles depuis la table `families` de Supabase
  Future<void> loadFamiliesFromSupabase() async {
    final supabase = Supabase.instance.client;

    // On SELECT toutes les lignes
    final response = await supabase
        .from('families')
        .select('*');

    // Vérifier si une erreur s'est produite
    if (response.hasError) {
      debugPrint("Erreur lors du chargement des familles: ${response.errorMessage}");
      return;
    }

    // Si pas d'erreur, on récupère la liste (response.data)
    final data = response.data as List<dynamic>;
    _families.clear();
    for (var item in data) {
      _families.add(
        Family(
          id: item['id'] as int,
          name: item['name'] as String,
        ),
      );
    }
    notifyListeners();
  }

  /// Insère une nouvelle famille dans la table `families` de Supabase
  Future<void> addFamilyToSupabase(String familyName) async {
    final supabase = Supabase.instance.client;

    // Insertion : on fait un .insert(), puis on récupère la ligne insérée en .select()
    final response = await supabase
        .from('families')
        .insert({'name': familyName})
        .select()
        .single(); // ou .maybeSingle()

    // Vérifier erreur
    if (response.hasError) {
      debugPrint("Erreur lors de l'ajout de la famille: ${response.errorMessage}");
      return;
    }

    // Récupérer l'objet inséré
    final inserted = response.data;
    final newFamily = Family(
      id: inserted['id'] as int,
      name: inserted['name'] as String,
    );

    // Mettre à jour la liste locale
    _families.add(newFamily);
    notifyListeners();
  }
}
