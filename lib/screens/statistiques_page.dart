import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/theme/app_theme.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';

class StatistiquesPage extends StatelessWidget {
  const StatistiquesPage({super.key}); // plus de paramètre

  @override
  Widget build(BuildContext context) {
    // watch : la page est reconstruite à chaque changement des zones
    // (toujours TOUTES les zones, même si le filtre est actif)
    final zones = context.watch<ZonesProvider>().zones;

    final tri = [...zones]..sort((a, b) => a.humidite.compareTo(b.humidite));
    final aIrriguer = zones.where((z) => z.besoinIrrigation).length;
    final pourcentage =
    zones.isEmpty ? 0 : (aIrriguer * 100 / zones.length).round();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Statistiques'),
      ),
      body: zones.isEmpty
          ? const Center(child: Text('Aucune donnée à afficher'))
          : ListView(
        children: [
          ResumeExploitation(zones: zones),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '$aIrriguer zone(s) sur ${zones.length} à irriguer '
                  '($pourcentage %)',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Humidité par zone',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final z in tri)
            ListTile(
              title: Text(z.nom),
              subtitle: LinearProgressIndicator(
                value: (z.humidite / 100).clamp(0.0, 1.0),
                color: z.besoinIrrigation
                    ? AppTheme.echec
                    : AppTheme.succes,
              ),
              trailing: Text('${z.humidite.toStringAsFixed(0)} %'),
            ),
        ],
      ),
    );
  }
}