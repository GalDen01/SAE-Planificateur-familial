import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  final supabase = Supabase.instance.client;

  int _pendingInvCount = 0;
  int get pendingInvCount => _pendingInvCount;

  Future<void> loadFamiliesForUser(String userEmail) async {
    try {
      final data = await supabase
          .from('families')
          .select('''
            id,
            name,
            family_members!inner(
              user_id,
              users!inner(email)
            )
          ''')
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
      debugPrint("Erreur loadFamiliesForUser: $e");
    }
  }

  Future<void> loadPendingInvitationsCount(int userId) async {
    try {
      final res = await supabase
          .from('family_invitations')
          .select('id, status')
          .eq('invited_user_id', userId)
          .eq('status', 'pending');

      _pendingInvCount = res.length;
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur loadPendingInvitationsCount: $e");
      _pendingInvCount = 0;
      notifyListeners();
    }
  }

  // ================== MÉTHODE AJOUTÉE ==================
  Future<List<Map<String, dynamic>>> fetchMembersOfFamily(int familyId) async {
    try {
      final result = await supabase
          .from('family_members')
          .select('user_id, users!inner(first_name, email, photo_url)')
          .eq('family_id', familyId);

      return result.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint("Erreur fetchMembersOfFamily: $e");
      return [];
    }
  }

  Future<void> addFamilyToSupabase(String familyName, String? userEmail) async {
    try {
      final data = await supabase
          .from('families')
          .insert({'name': familyName})
          .select()
          .single();

      final newFamilyId = data['id'] as int;
      final newFamilyName = data['name'] as String;
      _families.add(Family(id: newFamilyId, name: newFamilyName));
      notifyListeners();

      if (userEmail != null) {
        final userRes = await supabase
            .from('users')
            .select('id')
            .eq('email', userEmail)
            .maybeSingle();

        if (userRes != null && userRes['id'] != null) {
          final userId = userRes['id'] as int;
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

  // ================== INVITATIONS ==================

  Future<List<Map<String, dynamic>>> getInvitationsForUser(int userId) async {
    try {
      final res = await supabase
          .from('family_invitations')
          .select('id, family_id, status, families(name)')
          .eq('invited_user_id', userId)
          .eq('status', 'pending');
      return res.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint("Erreur getInvitationsForUser: $e");
      return [];
    }
  }

  Future<void> acceptFamilyInvitation(int invitationId) async {
    try {
      final inv = await supabase
          .from('family_invitations')
          .select('*')
          .eq('id', invitationId)
          .maybeSingle();

      if (inv == null) {
        throw Exception("Invitation introuvable.");
      }

      final familyId = inv['family_id'] as int;
      final invitedUserId = inv['invited_user_id'] as int;

      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': invitedUserId,
      });

      await supabase
          .from('family_invitations')
          .delete()
          .eq('id', invitationId);

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur acceptFamilyInvitation: $e");
      rethrow;
    }
  }

  Future<void> declineFamilyInvitation(int invitationId) async {
    try {
      final inv = await supabase
          .from('family_invitations')
          .select('*')
          .eq('id', invitationId)
          .maybeSingle();

      if (inv == null) {
        throw Exception("Invitation introuvable.");
      }

      await supabase
          .from('family_invitations')
          .update({'status': 'declined'})
          .eq('id', invitationId);

      notifyListeners();
    } catch (e) {
      debugPrint("Erreur declineFamilyInvitation: $e");
      rethrow;
    }
  }

  Future<void> inviteMemberToFamily(int familyId, int userId) async {
    try {
      final existingMember = await supabase
          .from('family_members')
          .select('id')
          .eq('family_id', familyId)
          .eq('user_id', userId)
          .maybeSingle();
      if (existingMember != null) {
        throw Exception("Cet utilisateur fait déjà partie de cette famille.");
      }

      final existingInv = await supabase
          .from('family_invitations')
          .select('id')
          .eq('family_id', familyId)
          .eq('invited_user_id', userId)
          .eq('status', 'pending')
          .maybeSingle();
      if (existingInv != null) {
        throw Exception("Une invitation en attente existe déjà pour cet utilisateur.");
      }

      await supabase.from('family_invitations').insert({
        'family_id': familyId,
        'invited_user_id': userId,
        'status': 'pending',
      });
    } catch (e) {
      debugPrint("Erreur inviteMemberToFamily: $e");
      rethrow;
    }
  }

  Future<void> deleteMemberToFamilyByUserId(int familyId, String userId) async {
    try {
      final existing = await supabase
          .from('family_members')
          .select('id')
          .eq('family_id', familyId)
          .eq('user_id', userId as int)
          .maybeSingle();

      if (existing != null && existing['id'] != null) {
        final deleteResponse = await supabase
            .from('family_members')
            .delete()
            .eq('family_id', familyId)
            .eq('user_id', userId);

        if (deleteResponse.error == null) {
          debugPrint("Membre supprimé avec succès.");
          notifyListeners();
        } else {
          throw Exception("Erreur lors de la suppression du membre.");
        }
      } else {
        throw Exception("Cet utilisateur ne fait pas partie de cette famille.");
      }
    } catch (e) {
      debugPrint("Erreur deleteMemberToFamilyByUserId: $e");
      rethrow;
    }
  }

  Future<void> leaveFamily(int familyId, String userEmail) async {
    try {
      final userRes = await supabase
          .from('users')
          .select('id')
          .eq('email', userEmail)
          .maybeSingle();

      if (userRes == null || userRes['id'] == null) {
        throw Exception("Impossible de trouver votre compte dans la BDD.");
      }
      final userId = userRes['id'] as int;

      await supabase
          .from('family_members')
          .delete()
          .eq('family_id', familyId)
          .eq('user_id', userId);

      await loadFamiliesForUser(userEmail);
    } catch (e) {
      debugPrint("Erreur leaveFamily: $e");
      rethrow;
    }
  }
}
