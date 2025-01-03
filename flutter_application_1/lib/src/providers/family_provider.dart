import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  /// Ne ramène QUE les familles où l'utilisateur est dans `family_members`,
  /// jointure sur `users` (email)
  Future<void> loadFamiliesForUser(String userEmail) async {
    final supabase = Supabase.instance.client;
    try {
      final data = await supabase
          // on part de la table families
          .from('families')
          // on joint la table family_members et la table users
          .select('''
            id,
            name,
            family_members!inner(
              user_id,
              users!inner(email)
            )
          ''')
          // on filtre pour avoir seulement
          // "family_members.users.email == userEmail"
          .eq('family_members.users.email', userEmail);

      _families.clear();

      // Si la requête a renvoyé une liste
      if (data is List) {
        for (final item in data) {
          _families.add(
            Family(
              id: item['id'] as int,
              name: item['name'] as String,
            ),
          );
        }
      } else {
        // Si ce n'est pas une liste (erreur, etc.)
        debugPrint("La requête Supabase n'a pas renvoyé de liste: $data");
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur dans loadFamiliesForUser: $e");
    }
  }

  Future<void> addFamilyToSupabase(String familyName, String? userEmail) async {
    final supabase = Supabase.instance.client;
    try {
      // Insert dans families
      final data = await supabase
          .from('families')
          .insert({'name': familyName})
          .select()
          .single();

      final newFamilyId = data['id'] as int;
      final newFamilyName = data['name'] as String;
      final newFamily = Family(id: newFamilyId, name: newFamilyName);
      _families.add(newFamily);
      notifyListeners();

      // Récupérer l'utilisateur depuis `users` (si userEmail != null)
      if (userEmail != null) {
        final userRes = await supabase
            .from('users')
            .select('id')
            .eq('email', userEmail)
            .maybeSingle();
        if (userRes != null && userRes['id'] != null) {
          final userId = userRes['id'] as int;
          // Insert dans family_members
          await supabase.from('family_members').insert({
            'family_id': newFamilyId,
            'user_id': userId,
          });
        }
      }
    } catch (e) {
      debugPrint("Erreur addFamilyToSupabase: $e");
    }
  }

  Future<void> addMemberToFamilyByUserId(int familyId, int userId) async {
    final supabase = Supabase.instance.client;
    try {
      // Vérifier si déjà dans la table
      final existing = await supabase
          .from('family_members')
          .select('id')
          .eq('family_id', familyId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        throw Exception("Cet utilisateur fait déjà partie de cette famille.");
      }

      // Sinon on insère
      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': userId,
      });
    } catch (e) {
      debugPrint("Erreur addMemberToFamilyByUserId: $e");
      rethrow;
    }
  }

  /// Récupérer la liste des membres d'une famille
  Future<List<Map<String, dynamic>>> getMembersOfFamily(int familyId) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('family_members')
        .select('user_id, users!inner(first_name, email)')
        .eq('family_id', familyId);

    return response.cast<Map<String, dynamic>>();
  }
}
