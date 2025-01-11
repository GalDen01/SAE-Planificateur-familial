// lib/src/providers/family_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  final supabase = Supabase.instance.client;

  // Charge les familles où l'utilisateur est déjà membre
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

      if (data is List) {
        for (final item in data) {
          _families.add(
            Family(
              id: item['id'] as int,
              name: item['name'] as String,
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur loadFamiliesForUser: $e");
    }
  }

  // Crée une famille + associe l'utilisateur créateur
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

  // Ajoute directement un user dans la famille (sans invitation)
  Future<void> addMemberToFamilyByUserId(int familyId, int userId) async {
    try {
      // Vérifier si déjà présent
      final existing = await supabase
          .from('family_members')
          .select('id')
          .eq('family_id', familyId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existing != null) {
        throw Exception("Cet utilisateur fait déjà partie de cette famille.");
      }

      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': userId,
      });
    } catch (e) {
      debugPrint("Erreur addMemberToFamilyByUserId: $e");
      rethrow;
    }
  }

  // ================== INVITATIONS ==================

  // Invite un utilisateur (crée un enregistrement 'pending' dans family_invitations)
  Future<List<Map<String, dynamic>>> getInvitationsForUser(int userId) async {
    try {
      final res = await supabase
          .from('family_invitations')
          .select('id, family_id, status, families(name)')
          .eq('invited_user_id', userId)
          .eq('status', 'pending');

      if (res is List) {
        return res.cast<Map<String, dynamic>>();
      }
      return [];
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

      // Insérer dans family_members
      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': invitedUserId,
      });

      // Supprimer ou mettre 'accepted' => on supprime le record
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

  // NOUVEAU : refuser l'invitation => on met status = 'declined' (ou on .delete() si vous préférez)
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

      // On met le status à 'declined'
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

  // Méthode pour inviter => existante
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

      // Insertion
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

  // =================================================

  // Supprimer un membre de la famille
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

  // Quitter la famille
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
