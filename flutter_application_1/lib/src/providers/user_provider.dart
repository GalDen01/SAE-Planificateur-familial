

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchAllUserData(int userId) async {
    final result = <String, dynamic>{};

    try {
      //Récupère la ligne dans `users`
      final userRes = await supabase
          .from('users')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      result['user'] = userRes ?? {};

      //Récupère les lignes de family_members
      final membersRes = await supabase
          .from('family_members')
          .select('id, family_id')
          .eq('user_id', userId);

      result['family_members'] = membersRes ?? [];

      //Récupère les invitations
      final invitationsRes = await supabase
          .from('family_invitations')
          .select('id, family_id, status')
          .eq('invited_user_id', userId);

      result['family_invitations'] = invitationsRes ?? [];


      return result;
    } catch (e) {
      debugPrint("Erreur fetchAllUserData: $e");
      rethrow;
    }
  }


  Future<void> deleteAllUserData(int userId) async {
    try {
      //Supprime dans family_invitations
      await supabase
          .from('family_invitations')
          .delete()
          .eq('invited_user_id', userId);

      //Supprime dans family_members
      await supabase
          .from('family_members')
          .delete()
          .eq('user_id', userId);

      //Supprime l’utilisateur
      await supabase
          .from('users')
          .delete()
          .eq('id', userId);

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur deleteAllUserData: $e");
      rethrow;
    }
  }
}
