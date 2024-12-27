import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  // Instance de GoogleSignIn (paramètre scopes si besoin)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
);


  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // Connexion via Google
  Future<void> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _currentUser = account;
        notifyListeners();

        // => on crée/MAJ l'utilisateur en BDD
        await createOrUpdateUserInSupabase();
      }
    } catch (error) {
      debugPrint("Erreur lors de la connexion Google: $error");
    }
  }
  //si l'utilisateur à déjà accepté
  Future<void> silentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        notifyListeners();
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

  /// Insère ou met à jour l'utilisateur dans la table `users` (id, email, first_name)
  Future<void> createOrUpdateUserInSupabase() async {
    if (_currentUser == null) return;
    final supabase = Supabase.instance.client;

    final email = _currentUser!.email;
    final displayName = _currentUser!.displayName; // ou givenName

    try {
      // upsert => s'il existe, on met à jour first_name, sinon on le crée
      await supabase
          .from('users')
          .upsert({
            'email': email,
            'first_name': displayName ?? '',
          }, onConflict: 'email'); // sur 'email'
    } catch (e) {
      debugPrint("Erreur createOrUpdateUserInSupabase: $e");
    }
  }
}
