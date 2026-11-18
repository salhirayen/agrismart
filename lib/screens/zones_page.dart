import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrismart/models/zone.dart';
import 'package:agrismart/providers/zones_provider.dart';
import 'package:agrismart/screens/zone_detail_page.dart';
import 'package:agrismart/screens/zone_form_page.dart';
import 'package:agrismart/widgets/fiche_exploitation.dart';
import 'package:agrismart/widgets/resume_exploitation.dart';
import 'package:agrismart/widgets/zone_card.dart';

// Onglet Zones : plus aucun paramètre, tout vient de ZonesProvider.
class ZonesPage extends StatelessWidget {
  const ZonesPage({super.key});

  void _message(BuildContext context, String texte) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texte), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _ajouter(BuildContext context) async {
    final noms = context.read<ZonesProvider>().noms();
    final nouvelle = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneFormPage(nomsExistants: noms),
      ),
    );
    if (nouvelle == null || !context.mounted) return;
    context.read<ZonesProvider>().ajouter(nouvelle);
    _message(context, 'Zone ajoutée');
  }

  Future<void> _ouvrirDetail(BuildContext context, Zone zone) async {
    final noms = context.read<ZonesProvider>().noms(sauf: zone);
    final modifiee = await Navigator.push<Zone>(
      context,
      MaterialPageRoute(
        builder: (_) => ZoneDetailPage(zone: zone, nomsAutres: noms),
      ),
    );
    if (modifiee == null || !context.mounted) return;
    context.read<ZonesProvider>().remplacer(zone, modifiee);
    _message(context, 'Zone modifiée');
  }

  Future<void> _confirmerSuppression(BuildContext context, Zone zone) async {
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
    if (confirme != true || !context.mounted) return;
    context.read<ZonesProvider>().supprimer(zone);
    _message(context, 'Zone ${zone.nom} supprimée');
  }

  Widget _carte(BuildContext context, Zone zone) {
    // read : on veut appeler une méthode, pas s'abonner
    final provider = context.read<ZonesProvider>();
    return ZoneCard(
      zone: zone,
      onAugmenter: () => provider.modifierHumidite(zone, 5),
      onDiminuer: () => provider.modifierHumidite(zone, -5),
      onTap: () => _ouvrirDetail(context, zone),
      onLongPress: () => _confirmerSuppression(context, zone),
    );
  }

  @override
  Widget build(BuildContext context) {
    // watch : la page est reconstruite à chaque changement
    final provider = context.watch<ZonesProvider>();
    final zones = provider.zones; // toutes les zones (résumé en haut)
    final affichees = provider.zonesAffichees; // zones de la liste (filtre)
    final filtre = provider.seulementAIrriguer;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AgriSmart'),
        centerTitle: true,
        actions: [
          // Exercice 1 : filtre
          IconButton(
            tooltip: filtre ? 'Afficher toutes les zones' : 'Zones à irriguer',
            onPressed: () => context.read<ZonesProvider>().basculerFiltre(),
            icon: Icon(filtre ? Icons.filter_alt : Icons.filter_alt_off),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ajouter(context),
        tooltip: 'Ajouter une zone',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          FicheExploitation(zones: zones),
          ResumeExploitation(zones: zones),
          Expanded(
            child: affichees.isEmpty
                ? Center(
              child: Text(
                filtre
                    ? 'Aucune zone à irriguer'
                    : 'Aucune zone pour le moment',
              ),
            )
                : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 600) {
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: affichees.length,
                    itemBuilder: (context, index) =>
                        _carte(context, affichees[index]),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                  itemCount: affichees.length,
                  itemBuilder: (context, index) =>
                      _carte(context, affichees[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}