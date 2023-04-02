import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:water_report/theme/color.dart';

import '../../env.sample.dart';

class OtherWidget extends StatefulWidget {
  const OtherWidget({super.key});

  @override
  State<OtherWidget> createState() => _OtherWidgetState();
}

class _OtherWidgetState extends State<OtherWidget> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, secondary],
                      ),
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: 110.0,
                      ),
                      CircleAvatar(
                        radius: 65.0,
                        backgroundImage: AssetImage('assets/images/ezra.png'),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('$nom',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(
                        height: 0,
                      ),
                      // Text(
                      //   'S Class Mage',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 15.0,
                      //   ),
                      // )
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                        child: Card(
                            margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                            child: Container(
                                width: 310.0,
                                height: 290.0,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 0.0,
                                      left: 5.0,
                                      right: 5.0,
                                      top: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Information",
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey[300],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Prenom",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "$prenom",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "$lemail",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Téléphone",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "${numtel.toString()}",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Adresse",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "$adresse",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date Embauche",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "${date_embauche.toString()}",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
