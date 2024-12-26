import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  // Instance de GoogleSignIn (paramètre scopes si besoin)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // scopes: ['email'],
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
}
