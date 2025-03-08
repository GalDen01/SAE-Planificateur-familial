import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchAllUserData(int userId) async {
    final result = <String, dynamic>{};

    try {
      final userRes = await supabase
          .from('users')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      // S’il peut réellement être null, on l’affecte directement (ce qui stocke null).
      // Sinon, on l’assigne tel quel :
      result['user'] = userRes;

      final membersRes = await supabase
          .from('family_members')
          .select('id, family_id')
          .eq('user_id', userId);

      // Idem ici
      result['family_members'] = membersRes;

      final invitationsRes = await supabase
          .from('family_invitations')
          .select('id, family_id, status')
          .eq('invited_user_id', userId);

      result['family_invitations'] = invitationsRes;

      return result;
    } catch (e) {
      debugPrint("Erreur fetchAllUserData: $e");
      rethrow;
    }
  }

  Future<void> deleteAllUserData(int userId) async {
    try {
      await supabase
          .from('family_invitations')
          .delete()
          .eq('invited_user_id', userId);

      await supabase
          .from('family_members')
          .delete()
          .eq('user_id', userId);

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
