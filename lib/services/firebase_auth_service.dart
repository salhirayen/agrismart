import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agrismart/models/utilisateur.dart';
import 'package:agrismart/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<Utilisateur?> get utilisateur {
    // TODO 1 : flux Firebase transformé en Utilisateur
    return _auth.authStateChanges().map((u) {
      if (u == null) return null;
      return Utilisateur(uid: u.uid, email: u.email ?? '');
    });
  }

  @override
  Future<void> connexion(String email, String motDePasse) {
    // TODO 2
    return _executer(() => _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: motDePasse,
    ));
  }

  @override
  Future<void> inscription(String email, String motDePasse) {
    // TODO 3
    return _executer(() => _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: motDePasse,
    ));
  }

  @override
  Future<void> reinitialiserMotDePasse(String email) {
    return _executer(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  @override
  Future<void> deconnexion() => _auth.signOut();

  // Exécute une opération Firebase et traduit les erreurs en français
  Future<void> _executer(Future<void> Function() operation) async {
    try {
      await operation();
    } on FirebaseAuthException catch (e) {
      debugPrint('FIREBASE CODE: ${e.code} | ${e.message}');
      throw AuthException(_traduire(e.code));
    } catch (e) {
      debugPrint('AUTRE ERREUR: $e');
      throw const AuthException('Une erreur est survenue');
    }
  }

  String _traduire(String code) {
    switch (code) {
      case 'invalid-email':
        return "L'adresse email n'est pas valide";
    // TODO 4
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect';
    // TODO 5
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'weak-password':
        return 'Mot de passe trop faible (6 caractères minimum)';
      case 'network-request-failed':
        return 'Pas de connexion Internet';
      case 'too-many-requests':
        return 'Trop de tentatives, réessayez plus tard';
      default:
        return "Erreur d'authentification ($code)";
    }
  }
}