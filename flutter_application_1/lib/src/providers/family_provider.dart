import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  Future<void> loadFamiliesForUser(String userEmail) async {
    final supabase = Supabase.instance.client;
    try {
      // jointure
      final data = await supabase
        .from('families')
        .select('id, name, family_members!inner(user_id, user_email:users(email))')
        .eq('family_members.users.email', userEmail);

      _families.clear();
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
      debugPrint("Erreur: $e");
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
      await supabase
          .from('family_members')
          .insert({
            'family_id': familyId,
            'user_id': userId,
          });
    } catch (e) {
      debugPrint("Erreur addMemberToFamilyByUserId: $e");
    }
  }
}
