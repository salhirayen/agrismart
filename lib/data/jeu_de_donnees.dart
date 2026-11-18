import 'package:agrismart/models/zone.dart';

List<Zone> jeuDeDonnees() {
  return [
    Zone(
      nom: 'Parcelle Nord',
      culture: 'Tomates',
      humidite: 28,
      seuil: 35,
    ),

    Zone(
      nom: 'Parcelle Sud',
      culture: 'Oliviers',
      humidite: 42,
      seuil: 30,
    ),

    Zone(
      nom: 'Serre 1',
      culture: 'Fraises',
      humidite: 55,
      seuil: 50,
      vanneOuverte: true,
    ),

    Zone(
      nom: 'Parcelle Est',
      culture: 'Blé',
      humidite: 20,
      seuil: 35,
    ),

    Zone(
      nom: 'Parcelle Ouest',
      culture: 'Orge',
      humidite: 38,
      seuil: 35,
    ),

    Zone(
      nom: 'Serre 2',
      culture: 'Poivrons',
      humidite: 60,
      seuil: 55,
    ),

    Zone(
      nom: 'Verger',
      culture: 'Pommiers',
      humidite: 33,
      seuil: 30,
    ),

    Zone(
      nom: 'Parcelle Centre',
      culture: 'Luzerne',
      humidite: 25,
      seuil: 40,
    ),

    Zone(
      nom: 'Serre 3',
      culture: 'Concombres',
      humidite: 70,
      seuil: 60,
    ),

    Zone(
      nom: 'Palmeraie',
      culture: 'Dattiers',
      humidite: 45,
      seuil: 40,
    ),
  ];
}