import 'package:flutter/material.dart';
import 'package:agrismart/widgets/zone_form.dart';

import '../models/zone.dart';
import '../data/jeu_de_donnees.dart';
import '../widgets/zone_card.dart';
import '../widgets/fiche_exploitation.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final List<Zone> _zones = jeuDeDonnees();

  void _modifierHumidite(Zone zone, double valeur) {
    setState(() {
      zone.humidite = (zone.humidite + valeur).clamp(0.0, 100.0);
    });
  }

  // Ajout (zone == null) ou modification (zone != null)
  void _ouvrirFormulaire({Zone? zone}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: ZoneForm(
              zone: zone,
              // Exercice 1 : noms des autres zones (sans la zone modifiée)
              nomsExistants:
              _zones.where((z) => z != zone).map((z) => z.nom).toList(),
              onEnregistrer: (nouvelle) {
                setState(() {
                  if (zone == null) {
                    _zones.add(nouvelle);
                  } else {
                    final index = _zones.indexOf(zone);
                    if (index != -1) _zones[index] = nouvelle;
                  }
                });
                Navigator.pop(ctx);
                // ALERTE 1 : SnackBar confirmation ajout/modif
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      zone == null ? 'Zone ajoutée' : 'Zone modifiée',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ALERTE 2 : Exercice 2 - suppression avec confirmation
  Future<void> _confirmerSuppression(Zone zone) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Supprimer la zone ${zone.nom} ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirme == true) {
      setState(() {
        _zones.remove(zone);
      });
      // ALERTE 3 : SnackBar confirmation suppression
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Zone ${zone.nom} supprimée'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _carte(Zone zone) {
    return ZoneCard(
      zone: zone,
      onAugmenter: () => _modifierHumidite(zone, 5),
      onDiminuer: () => _modifierHumidite(zone, -5),
      onTap: () => _ouvrirFormulaire(zone: zone),
      onLongPress: () => _confirmerSuppression(zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FicheExploitation(zones: _zones),
          Expanded(
            child: _zones.isEmpty
                ? const Center(child: Text('Aucune zone disponible'))
                : LayoutBuilder(
              builder: (context, contraintes) {
                if (contraintes.maxWidth >= 600) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _zones.length,
                    itemBuilder: (context, index) =>
                        _carte(_zones[index]),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _zones.length,
                  itemBuilder: (context, index) => _carte(_zones[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(),
        tooltip: 'Ajouter une zone',
        child: const Icon(Icons.add),
      ),
    );
  }
}