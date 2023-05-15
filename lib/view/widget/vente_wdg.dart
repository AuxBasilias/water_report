import 'dart:convert';

import 'package:flutter/material.dart';

import '../../env.sample.dart';
import '../../theme/color.dart';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:select_form_field/select_form_field.dart';

class VenteWidget extends StatefulWidget {
  const VenteWidget({super.key});

  @override
  State<VenteWidget> createState() => _VenteWidgetState();
}

class _VenteWidgetState extends State<VenteWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ventes'),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                Tab(text: 'Enregistrer Client'),
                Tab(
                  text: "Enregister Vente",
                ),
                Tab(
                  text: "Ventes",
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            AddClient(),
            AddVente(),
            Vente(),
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////////////////////////////////////Add Client/////////////////////////////////////////////////////
/////////////******************************************************************************************************************************** */
/////////////////////////////////////*////////////////*////////////////////*//****/////////////////////////////////////////////////////////// */

class AddClient extends StatefulWidget {
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _numTelController = TextEditingController();
  double? _longitude;
  double? _latitude;

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Afficher une boîte de dialogue pour demander à l'utilisateur d'activer les autorisations de localisation
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Autorisations de localisation'),
          content: Text(
              'Pour utiliser cette fonctionnalité, vous devez activer les autorisations de localisation.'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Activer les autorisations'),
              onPressed: () {
                // Ouvrir les paramètres de l'application pour que l'utilisateur puisse activer les autorisations de localisation
                Geolocator.openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {}
  }

  void _submitForm() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('En cours'),
        titlePadding: EdgeInsets.only(left: 90, top: 5),
        content: Padding(
          padding: const EdgeInsets.only(left: 75.0, right: 75.0),
          child: CircularProgressIndicator(
            strokeWidth: 5, // épaisseur de la ligne de progression
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
    //_requestLocationPermission();
    //final position = await Geolocator.getCurrentPosition();
    // setState(() {
    //   _longitude = position.longitude;
    //   _latitude = position.latitude;
    // });
    print(" la latitude est ça $_latitude");
    final client = {
      'nom': _nomController.text,
      'adresse': _adresseController.text,
      'numTel': _numTelController.text,
      'longitude': 6.126292,
      'latitude': 1.21123,
    };
    final response = await http.post(
      Uri.parse('$apiUrl/clients/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(client),
    );
    Navigator.pop(context);
    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(''),
                content: Text('Client crée avec succès.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du client')),
      );
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _requestLocationPermission();
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                    ),
                  ),
                  TextFormField(
                    controller: _adresseController,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                    ),
                  ),
                  TextFormField(
                    controller: _numTelController,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Créer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///
///
class AddVente extends StatefulWidget {
  const AddVente({super.key});

  @override
  State<AddVente> createState() => _AddVenteState();
}

class _AddVenteState extends State<AddVente> {
  //////////////////////////////////////////////////////////                               Variable

  final TextEditingController qte = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _produitContoller = TextEditingController();
  final TextEditingController _clientContoller = TextEditingController();
  List<dynamic> _produit = [];
  List<Map<String, dynamic>> _itemProduits = [];
  List<dynamic> _client = [];
  List<Map<String, dynamic>> _itemClients = [];
  bool _isLoading = true;

///////////////////////////////Fonctions
  Future<void> _fetchProduits() async {
    final response = await http.get(Uri.parse('$apiUrl/produits/'));
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _produit = data;
        _itemProduits = _produit.map((produit) {
          return {
            'value': produit['id'].toString(),
            'label': produit['nom'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch produits');
    }
  }

  Future<void> _fetchClients() async {
    final response = await http.get(Uri.parse('$apiUrl/clients/'));
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _client = data;
        _itemClients = _client.map((client) {
          return {
            'value': client['id'].toString(),
            'label': client['nom'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to fetch clients');
    }
  }

  void _submitFormV() async {
    final vente = {
      'quantite': qte.text,
      'produit': _produitContoller.text,
      'client': _clientContoller.text,
      'livreur': livreur_id,
    };
    final response = await http.post(
      Uri.parse('$apiUrl/ventes/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vente),
    );
    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(''),
                content: Text('Vente enrégistrée avec succès.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la l\'enrégistrement de la vente')),
      );
    }
  }

//////////////////////////@Overides
  ///
  @override
  void initState() {
    super.initState();
    _fetchClients();
    _fetchProduits().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : SafeArea(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SelectFormField(
                      controller: _produitContoller,
                      type: SelectFormFieldType.dialog,
                      labelText: 'Produit',
                      items: _itemProduits,
                      onChanged: (val) => print(val),
                      onSaved: (val) => print(val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SelectFormField(
                      controller: _clientContoller,
                      type: SelectFormFieldType.dialog,
                      labelText: 'Client',
                      items: _itemClients,
                      onChanged: (val) => print(val),
                      onSaved: (val) => print(val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: qte,
                      decoration: InputDecoration(hintText: "quantité"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _submitFormV();
                      },
                      child: const Text('Enregistrer'),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
///                                       Vente

class Vente extends StatefulWidget {
  const Vente({super.key});

  @override
  State<Vente> createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  List<dynamic> _ventes = [];

  Future<void> _fetchVentes() async {
    final response =
        await http.get(Uri.parse('$apiUrl/ventes/?livreur=$livreur_id'));
    if (response.statusCode == 200) {
      setState(() {
        _ventes = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load commandes');
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

  @override
  void initState() {
    super.initState();
    _fetchVentes();
    Future.delayed(Duration(seconds: 1)).then((value) {
      super.initState();
      _fetchVentes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _ventes.length,
      itemBuilder: (BuildContext context, int index) {
        final vente = _ventes[index];
        return FutureBuilder(
          future: Future.wait(
              [_fetchClient(vente['client']), _fetchProduit(vente['produit'])]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final client = snapshot.data[0];
              final produit = snapshot.data[1];
              return ExpansionTile(
                title: Text('Client : ${client['nom']} - ${produit['nom']}'),
                collapsedBackgroundColor: Color.fromARGB(255, 182, 211, 235),
                backgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: Text('Date : ${vente['date_vente']}'),
                  ),
                  ListTile(
                    title: Text('Quantité : ${vente['quantite'].toString()}'),
                  ),
                  ListTile(
                    title: Text(
                      'Prix Total: ${vente['prix_total'].toString()}',
                      style: TextStyle(color: Colors.green),
                    ),
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
