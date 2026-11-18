import 'package:flutter/foundation.dart';
import 'package:agrismart/data/jeu_de_donnees.dart';
import 'package:agrismart/models/zone.dart';

class ZonesProvider extends ChangeNotifier {
  final List<Zone> _zones = jeuDeDonnees();

  // Exercice 1 : filtre "seulement les zones à irriguer"
  bool _seulementAIrriguer = false;

  // copie en lecture seule : on ne modifie la liste que par les méthodes
  List<Zone> get zones => List.unmodifiable(_zones);

  // Exercice 1 : zones affichées dans l'onglet Zones (filtrées ou non)
  List<Zone> get zonesAffichees {
    if (!_seulementAIrriguer) return zones;
    return List.unmodifiable(_zones.where((z) => z.besoinIrrigation));
  }

  bool get seulementAIrriguer => _seulementAIrriguer;

  int get nombre => _zones.length;

  int get nombreAIrriguer => _zones.where((z) => z.besoinIrrigation).length;

  // Exercice 2 : humidité moyenne (0 si la liste est vide)
  double get humiditeMoyenne {
    if (_zones.isEmpty) return 0;
    final somme = _zones.fold<double>(0, (total, z) => total + z.humidite);
    return somme / _zones.length;
  }

  // noms des zones (sauf une), pour refuser un doublon dans le formulaire
  List<String> noms({Zone? sauf}) {
    return _zones.where((z) => z != sauf).map((z) => z.nom).toList();
  }

  void modifierHumidite(Zone zone, double delta) {
    // TODO 1
    zone.humidite = (zone.humidite + delta).clamp(0, 100).toDouble();
    notifyListeners();
  }

  void ajouter(Zone zone) {
    // TODO 2
    _zones.add(zone);
    notifyListeners();
  }

  void remplacer(Zone ancienne, Zone nouvelle) {
    // TODO 3
    final index = _zones.indexOf(ancienne);
    if (index == -1) return;
    _zones[index] = nouvelle;
    notifyListeners();
  }

  void supprimer(Zone zone) {
    // TODO 4
    _zones.remove(zone);
    notifyListeners();
  }

  // Exercice 1
  void basculerFiltre() {
    _seulementAIrriguer = !_seulementAIrriguer;
    notifyListeners();
  }
}