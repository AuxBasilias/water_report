import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:water_report/env.sample.dart';
import 'package:water_report/theme/color.dart';
import 'package:water_report/view/home.view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class CommandeWidget extends StatefulWidget {
  @override
  _CommandeWidget createState() => _CommandeWidget();
}

class _CommandeWidget extends State<CommandeWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Commandes'),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage()),
                  );
                })
          ],
          backgroundColor: Colors.greenAccent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, secondary],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: [
                Tab(text: 'En Attente'),
                Tab(
                  text: "En cours",
                ),
                Tab(text: 'Livreé'),
              ]),
        ),
        body: TabBarView(
          children: [
            Commande_en_attente(),
            EnCours(),
            Historique(),
          ],
        ),
      ),
    );
  }
}

class Commande_en_attente extends StatefulWidget {
  const Commande_en_attente({super.key});

  @override
  State<Commande_en_attente> createState() => _Commande_en_attenteState();
}

class _Commande_en_attenteState extends State<Commande_en_attente> {
  List<dynamic> _commandesAttente = [];
  List<dynamic> _commandes = [];

  Future<List<dynamic>> _fetchCommandes() async {
    final response = await http.get(Uri.parse('$apiUrl/commandes/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load commandes');
    }
  }

  Future<void> _fetchCommandesAttente() async {
    try {
      List<dynamic> commandes = await _fetchCommandes();
      setState(() {
        _commandesAttente = commandes
            .where((commande) => commande['etat'] == 'EN ATTENTE')
            .toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> _fetchClient(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/clients/$clientId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<dynamic> _fetchProduit(int produitId) async {
    final response = await http.get(Uri.parse('$apiUrl/produits/$produitId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<void> _livrerCommande(int idCommande) async {
    final response = await http.patch(
        Uri.parse('$apiUrl/commandes/$idCommande/'),
        body: {'etat': 'EN COURS'});
    final lcmd = {
      'commande': idCommande.toInt(),
      'livreur': livreur_id.toInt(),
    };
    final response2 = await http.post(Uri.parse('$apiUrl/lignecommandes/'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(lcmd));
    if (response.statusCode == 200 && response2.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Livraison en cours'),
            content: Text('La commande est en cours de livraison.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // La commande a été livrée avec succès
    } else {
      throw Exception('Impossible de livrer la commande');
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchCommandes().then((commandes) {
      setState(() {
        _commandes = commandes;
      });
    });

    _fetchCommandesAttente();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _commandesAttente.length,
      itemBuilder: (BuildContext context, int index) {
        final commande = _commandesAttente[index];
        return FutureBuilder(
          future: Future.wait([
            _fetchClient(commande['client']),
            _fetchProduit(commande['produit'])
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final client = snapshot.data[0];
              final produit = snapshot.data[1];
              return ExpansionTile(
                title: Text('${client['nom']} - ${client['adresse']}'),
                collapsedBackgroundColor: Color.fromARGB(255, 182, 211, 235),
                backgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Date : ${commande['date_commande']}'),
                  ),
                  ListTile(
                    title: Text('Produit : ${produit['nom']}'),
                  ),
                  ListTile(
                    title: Text('Quantité : ${commande['quantite']}'),
                  ),
                  ListTile(
                    title: Text('Etat : ${commande['etat']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Prix : ${commande['prix_total'].toString()}',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                        child: Text('Livrer'),
                        onPressed: () async {
                          await _livrerCommande(commande['id']);
                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarteClient(
                                  latitude: 37.7749,
                                  longitude: -122.4194,
                                  name: "Client",
                                ),
                              )
                              );*/
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}

class EnCours extends StatefulWidget {
  const EnCours({super.key});

  @override
  State<EnCours> createState() => _EnCoursState();
}

class _EnCoursState extends State<EnCours> {
  List<dynamic> _commandesEcours = [];

  Future<void> _fetchComEcours(String livreurId) async {
    final response =
        await http.get(Uri.parse('$apiUrl/lignecommandes/?livreur=$livreurId'));
    final List<dynamic> lcommandes = jsonDecode(response.body);

    List<dynamic> comEcours = [];
    for (var lcommande in lcommandes) {
      var commandeId = lcommande['commande'];
      var commandesResponse =
          await http.get(Uri.parse('$apiUrl/commandes/$commandeId/'));
      var commande = jsonDecode(commandesResponse.body);
      if (commande['etat'] == 'EN COURS') {
        comEcours.add(commande);
      }
    }

    setState(() {
      _commandesEcours = comEcours;
    });
  }

  Future<dynamic> _fetchClient(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/clients/$clientId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<dynamic> _fetchProduit(int produitId) async {
    final response = await http.get(Uri.parse('$apiUrl/produits/$produitId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<void> _terminerLivraison(int idCommande) async {
    final response = await http.patch(
        Uri.parse('$apiUrl/commandes/$idCommande/'),
        body: {'etat': 'LIVREE'});

    if (response.statusCode == 200) {
      // La commande a été livrée avec succès
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Livraison terminée'),
            content: Text('La commande est livrée avec succès.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      throw Exception('Impossible de livrer la commande');
    }
  }

  Future<void> _annulerCommande(int idCommande) async {
    final response = await http.patch(
      Uri.parse('$apiUrl/commandes/$idCommande/'),
      body: {'etat': 'EN ATTENTE'},
    );

    final response2 = await http
        .get(Uri.parse('$apiUrl/lignecommandes/?commande=$idCommande'));
    final lignesCommandes = jsonDecode(response2.body);
    final ligneCommandeId = lignesCommandes[0]['id'];

    final response3 = await http.delete(
      Uri.parse('$apiUrl/lignecommandes/$ligneCommandeId/'),
    );

    if (response.statusCode == 200 && response3.statusCode == 204) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Commande annulée'),
            content: Text('La commande a été annulée avec succès.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      // La commande a été annulée avec succès
    } else {
      throw Exception('Impossible d\'annuler la commande');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///G Maps
  void openGoogleMapsApp(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Impossible d\'ouvrir Google Maps';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComEcours(livreur_id.toString());

    print(
      _commandesEcours.length,
    );
    print(
      livreur_id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _commandesEcours.length,
      itemBuilder: (BuildContext context, int index) {
        final commande = _commandesEcours[index];
        return FutureBuilder(
          future: Future.wait([
            _fetchClient(commande['client']),
            _fetchProduit(commande['produit'])
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final client = snapshot.data[0];
              final produit = snapshot.data[1];
              return ExpansionTile(
                title: Text('${client['nom']} - ${client['adresse']}'),
                collapsedBackgroundColor: Color.fromARGB(255, 182, 211, 235),
                backgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Date : ${commande['date_commande']}'),
                  ),
                  ListTile(
                    title: Text('Produit : ${produit['nom']}'),
                  ),
                  ListTile(
                    title: Text('Quantité : ${commande['quantite']}'),
                  ),
                  ListTile(
                    title: Text('Etat : ${commande['etat']}'),
                  ),
                  ListTile(
                    title: Text(
                      'Prix : ${commande['prix_total'].toString()}',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            child: Text('Terminer'),
                            onPressed: () async {
                              await _terminerLivraison(commande['id']);
                            },
                          ),
                        ],
                      ),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            child: Text('Voir sur carte'),
                            onPressed: () async {
                              openGoogleMapsApp(
                                  client['latitude'], client['longitude']);
                            },
                          ),
                        ],
                      ),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            child: Text('Annuler'),
                            onPressed: () async {
                              await _annulerCommande(commande['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
class Historique extends StatefulWidget {
  const Historique({super.key});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {
  List<dynamic> _commandesLivrees = [];

  Future<void> _fetchCommandesLivrees(String livreurId) async {
    final response =
        await http.get(Uri.parse('$apiUrl/lignecommandes/?livreur=$livreurId'));
    final List<dynamic> lcommandes = jsonDecode(response.body);

    List<dynamic> comLcours = [];
    for (var lcommande in lcommandes) {
      var commandeId = lcommande['commande'];
      var commandesResponse =
          await http.get(Uri.parse('$apiUrl/commandes/$commandeId/'));
      var commande = jsonDecode(commandesResponse.body);
      if (commande['etat'] == 'LIVREE') {
        comLcours.add(commande);
      }
    }

    setState(() {
      _commandesLivrees = comLcours;
    });
  }

  Future<dynamic> _fetchClient(int clientId) async {
    final response = await http.get(Uri.parse('$apiUrl/clients/$clientId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<dynamic> _fetchProduit(int produitId) async {
    final response = await http.get(Uri.parse('$apiUrl/produits/$produitId/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<dynamic> _fetchLigneCommande(int idCommande) async {
    final response = await http.get(
        Uri.parse('$apiUrl/lignecommandes/?commande=${idCommande.toString()}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCommandesLivrees(livreur_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _commandesLivrees.length,
      itemBuilder: (BuildContext context, int index) {
        final commande = _commandesLivrees[index];
        return FutureBuilder(
          future: Future.wait([
            _fetchClient(commande['client']),
            _fetchProduit(commande['produit']),
            // _fetchLigneCommande(commande['id'])
          ]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final client = snapshot.data[0];
              final produit = snapshot.data[1];
              // final lcommande = snapshot.data[2];
              return ExpansionTile(
                title: Text('${client['nom']} - ${client['adresse']}'),
                collapsedBackgroundColor: Color.fromARGB(255, 182, 211, 235),
                backgroundColor: Colors.white,
                children: [
                  ListTile(
                    title:
                        Text('Date de commande : ${commande['date_commande']}'),
                  ),
                  ListTile(
                    title: Text('Produit : ${produit['nom']}'),
                  ),
                  ListTile(
                    title:
                        Text('Quantité : ${commande['quantite'].toString()}'),
                  ),
                  ListTile(
                    title: Text('Etat : ${commande['etat']}'),
                  ),
                  // ListTile(
                  //   title: Text(
                  //       'Date de livraison : ${lcommande['date_livraison'].toString()}'),
                  // ),
                  SizedBox(
                    height: 19,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
