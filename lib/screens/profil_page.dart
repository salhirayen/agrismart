import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/auth_provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/a_propos_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _confirmerDeconnexion(BuildContext context) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirme != true || !context.mounted) return;
    // AuthGate revient tout seul à l'écran de connexion
    await context.read<AuthProvider>().deconnexion();
  }

  @override
  Widget build(BuildContext context) {
    final texte = Theme.of(context).textTheme;

    // select : on ne s'abonne qu'à chaque valeur dont on a besoin
    final nombreZones = context.select<ZonesProvider, int>((p) => p.nombre);
    final aIrriguer =
    context.select<ZonesProvider, int>((p) => p.nombreAIrriguer);
    final moyenne =
    context.select<ZonesProvider, double>((p) => p.humiditeMoyenne);
    final email = context.select<AuthProvider, String>(
          (a) => a.utilisateur?.email ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.agriculture, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Exploitation AgriSmart', style: texte.titleLarge),
          ),
          // l'email remplace l'ancien texte "Kébili, Tunisie"
          Center(child: Text(email)),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.grass),
            title: const Text('Zones suivies'),
            trailing: Text('$nombreZones'),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber),
            title: const Text('Zones à irriguer'),
            trailing: Text('$aIrriguer'),
          ),
          ListTile(
            leading: const Icon(Icons.water_drop),
            title: const Text('Humidité moyenne'),
            trailing: Text('${moyenne.toStringAsFixed(1)} %'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AProposPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Se déconnecter'),
            onTap: () => _confirmerDeconnexion(context),
          ),
        ],
      ),
    );
  }
}