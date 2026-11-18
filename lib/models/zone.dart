class Zone {
  final String nom;
  final String culture;
  double humidite;
  final double seuil;
  bool vanneOuverte;

  Zone({
    required this.nom,
    required this.culture,
    required this.humidite,
    required this.seuil,
    this.vanneOuverte = false,
  });

  bool get besoinIrrigation => humidite < seuil;

  String get diagnostic =>
      besoinIrrigation ? 'À irriguer' : 'Humidité suffisante';
}