import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/screens/app_shell.dart';
import 'package:agrismart/screens/connexion_page.dart';

// Aiguillage : choisit l'écran selon l'état d'authentification.
// Il se reconstruit tout seul à chaque connexion / déconnexion.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.initialise) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!auth.connecte) {
      return const ConnexionPage();
    }
    return const AppShell();
  }
}