import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  // scopes: ['email','profile'] pour récupérer displayName
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<void> signInWithGoogle() async {
  try {
    final account = await _googleSignIn.signIn();
    if (account != null) {

      _currentUser = account;
      notifyListeners();

      // Créer/MàJ l'utilisateur en DB
      await createOrUpdateUserInSupabase();
    } else {
      debugPrint("GoogleSignIn annulé par l'utilisateur");
    }
  } catch (error) {
    debugPrint("Erreur lors de la connexion Google: $error");
  }
}


  Future<void> silentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        notifyListeners();
        // Créer/MAJ l'user en DB
        await createOrUpdateUserInSupabase();
      }
    } catch (error) {
      debugPrint("Erreur lors de la connexion silencieuse: $error");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (error) {
      debugPrint("Erreur lors de la déconnexion Google: $error");
    }
  }

  // Nouvelle méthode
  Future<void> createOrUpdateUserInSupabase() async {
    if (_currentUser == null) return;
    final supabase = Supabase.instance.client;

    final email = _currentUser!.email;
    final displayName = _currentUser!.displayName ?? '';  // "Prénom"

    try {
      // upsert => insert ou update sur la table 'users' selon l'email
      await supabase
          .from('users')
          .upsert({
            'email': email,
            'first_name': displayName,
          }, onConflict: 'email'); 
    } catch (e) {
      debugPrint("Erreur createOrUpdateUserInSupabase: $e");
    }
  }
}
