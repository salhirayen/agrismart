import 'package:flutter/material.dart';
import '../models/zone.dart';
import '../theme/app_theme.dart';

class ZoneCard extends StatelessWidget {
  final Zone zone;
  final VoidCallback onAugmenter;
  final VoidCallback onDiminuer;
  final VoidCallback? onTap; // ouvrir la fiche (appui)
  final VoidCallback? onLongPress; // supprimer (appui long)

  const ZoneCard({
    super.key,
    required this.zone,
    required this.onAugmenter,
    required this.onDiminuer,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bool besoinEau = zone.besoinIrrigation;

    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.eco, color: Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      zone.nom,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Culture : ${zone.culture}'),
              const SizedBox(height: 8),
              Text(
                zone.diagnostic,
                style: TextStyle(
                  color: besoinEau ? AppTheme.echec : AppTheme.succes,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (zone.humidite / 100).clamp(0.0, 1.0),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text('Humidité : ${zone.humidite.toStringAsFixed(0)} %'),
              Text('Seuil : ${zone.seuil.toStringAsFixed(0)} %'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Diminuer l’humidité',
                    onPressed: onDiminuer,
                    icon: const Icon(Icons.remove_circle),
                  ),
                  IconButton(
                    tooltip: 'Augmenter l’humidité',
                    onPressed: onAugmenter,
                    icon: const Icon(Icons.add_circle),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}