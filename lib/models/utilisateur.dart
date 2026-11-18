// Utilisateur connecté (on ne garde que ce dont l'application a besoin)
class Utilisateur {
  final String uid;
  final String email;

  const Utilisateur({required this.uid, required this.email});
}