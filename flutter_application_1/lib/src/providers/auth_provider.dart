// lib/src/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'], 
    // 'profile' => donne accès à displayName, photoUrl
  );

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return;
      }

      _currentUser = account;
      notifyListeners();

      await createOrUpdateUserInSupabase();
    } catch (error) {
      debugPrint("Erreur signInWithGoogle: $error");
    }
  }


  Future<void> silentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        notifyListeners();
        await createOrUpdateUserInSupabase();
      }
    } catch (error) {
      debugPrint("Erreur silentSignIn: $error");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (error) {
      debugPrint("Erreur signOut: $error");
    }
  }

  /// Enregistre/MAJ l'utilisateur dans Supabase (table `users`) avec le champ `photo_url`.
  Future<void> createOrUpdateUserInSupabase() async {
    if (_currentUser == null) return;
    final supabase = Supabase.instance.client;

    final email = _currentUser!.email;
    final displayName = _currentUser!.displayName ?? '';
    final photoUrl = _currentUser!.photoUrl ?? ''; 

    try {
      // 'upsert' => insère ou met à jour la ligne users(email)
      await supabase
          .from('users')
          .upsert({
            'email': email,
            'first_name': displayName,
            'photo_url': photoUrl, 
          }, onConflict: 'email');
    } catch (e) {
      debugPrint("Erreur createOrUpdateUserInSupabase: $e");
    }
  }
}
