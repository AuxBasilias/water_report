import 'dart:ffi';

class Livreur {
  final int id;
  final String email;
  final String password;
  final String nom;
  final String adresse;
  final int stock;

  Livreur(
      {required this.id,
      required this.email,
      required this.password,
      this.nom = "",
      this.adresse = "",
      this.stock = 0});

  factory Livreur.fromJson(Map<String, dynamic> json) {
    return Livreur(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      nom: json['nom'] ?? "",
      adresse: json['adresse'] ?? "",
      stock: json['stock'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'nom': nom,
        'adresse': adresse,
        'stock': stock,
      };
}
