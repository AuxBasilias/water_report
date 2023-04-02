import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_report/utils/global.colors.dart';
import 'package:water_report/view/widget/button.global.dart';
import 'package:water_report/view/widget/test.form.global.dart';
import 'package:water_report/env.sample.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool is_loading = false;
  bool is_login = false;

  Future<List<dynamic>> fetchLivreurData() async {
    final response = await http.get(Uri.parse('$apiUrl/livreurs/'));
    if (response.statusCode == 200) {
      // setState(() {
      //   is_loading = false;
      // });

      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load livreur data');
    }
  }

  Future<bool> verifyLivreur(String email, String password) async {
    final livreurData = await fetchLivreurData();
    for (final livreur in livreurData) {
      if (livreur['email'] == email && livreur['password'] == password) {
        setState(() {
          livreur_id = livreur['id'];
          lemail = livreur['email'];
          nom = livreur['nom'];
          adresse = livreur['adresse'];
          date_embauche = livreur['date_embauche'];
          numtel = livreur['numTel'];
          prenom = livreur['prenom'];
        });
        return true;
      }
    }

    return false;
  }

  Future<void> login(String email, String password) async {
    setState(() {
      is_loading = true;
    });

    final isLivreurVerified = await verifyLivreur(email, password);

    setState(() {
      is_loading = false;
    });
    if (isLivreurVerified) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.0),
                  Text("Connexion en cours..."),
                ],
              ),
            ),
          );
        },
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Ferme le Dialog
        Navigator.of(context).pushNamed('/home');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de connexion'),
          content: Text('Email ou mot de passe incorrect.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    fetchLivreurData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: is_loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/es.png',
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      Text(
                        'Connectez vous',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: GlobalColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(
                        height: 19,
                      ),
                      /////Email input
                      TextFormGlobal(
                        controller: emailController,
                        text: 'Email',
                        obscure: false,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      /////password Input
                      TextFormGlobal(
                        controller: passwordController,
                        text: 'Password',
                        obscure: true,
                        textInputType: TextInputType.text,
                      ),

                      const SizedBox(
                        height: 37,
                      ),
                      InkWell(
                        onTap: () {
                          login(emailController.text, passwordController.text);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                              color: GlobalColors.mainColor,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10),
                              ]),
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
