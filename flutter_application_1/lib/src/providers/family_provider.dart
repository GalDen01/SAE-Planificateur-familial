// lib/src/providers/family_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

class FamilyProvider extends ChangeNotifier {
  final List<Family> _families = [];
  List<Family> get families => _families;

  /// Charge toutes les familles où l'utilisateur est MEMBRE (i.e. table family_members).
  Future<void> loadFamiliesForUser(String userEmail) async {
    final supabase = Supabase.instance.client;
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
      debugPrint("Erreur dans loadFamiliesForUser: $e");
    }
  }

  /// Crée une nouvelle famille ET y ajoute l'utilisateur créateur (si userEmail != null).
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
          // Insert direct dans family_members
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

  /// Auparavant : addMemberToFamilyByUserId => on l'utilise si on veut ajouter direct en BDD
  /// Désormais, on privilégie "inviteMemberToFamily" pour un workflow d'invitation.
  Future<void> addMemberToFamilyByUserId(int familyId, int userId) async {
    final supabase = Supabase.instance.client;
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

      // Insertion
      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': userId,
      });
    } catch (e) {
      debugPrint("Erreur addMemberToFamilyByUserId: $e");
      rethrow;
    }
  }

  // ================== NOUVEAUTÉS ==================

  /// Invite un utilisateur à rejoindre la famille => inscription dans `family_invitations`.
  Future<void> inviteMemberToFamily(int familyId, int userId) async {
    final supabase = Supabase.instance.client;
    try {
      // On peut vérifier s'il existe déjà une invitation
      // ou un membership, selon vos besoins.
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

  /// Récupère les invitations en attente pour un userId donné.
  Future<List<Map<String, dynamic>>> getInvitationsForUser(int userId) async {
    final supabase = Supabase.instance.client;
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

  /// Accepter une invitation => insère dans family_members, supprime l'invitation
  Future<void> acceptFamilyInvitation(int invitationId) async {
    final supabase = Supabase.instance.client;
    try {
      // 1) Récupération de l'invitation
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

      // 2) Insérer dans family_members
      await supabase.from('family_members').insert({
        'family_id': familyId,
        'user_id': invitedUserId,
      });

      // 3) Supprimer l'invitation
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

  // =================================================

  Future<void> deleteMemberToFamilyByUserId(int familyId, String userId) async {
    final supabase = Supabase.instance.client;
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

  /// Quitter la famille
  Future<void> leaveFamily(int familyId, String userEmail) async {
    final supabase = Supabase.instance.client;

    // 1) Récupérer l'id user
    final userRes = await supabase
        .from('users')
        .select('id')
        .eq('email', userEmail)
        .maybeSingle();

    if (userRes == null || userRes['id'] == null) {
      throw Exception("Impossible de trouver votre compte dans la BDD.");
    }

    final userId = userRes['id'] as int;

    // 2) Supprimer la ligne correspondante
    await supabase
        .from('family_members')
        .delete()
        .eq('family_id', familyId)
        .eq('user_id', userId);

    // 3) Recharger la liste
    await loadFamiliesForUser(userEmail);
  }
}
