import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:water_report/theme/color.dart';
import 'package:water_report/view/widget/carte_wdg.dart';

import 'widget/commande_wdg.dart';
import 'widget/other_wdg.dart';
import 'widget/vente_wdg.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Demander l'autorisation d'accès à la localisation de l'utilisateur
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: getTabs(),
      body: getBody(),
    );
  }

  Widget getTabs() {
    List<IconData> iconsItems = [
      MaterialCommunityIcons.view_grid,
      MaterialCommunityIcons.map,
      MaterialCommunityIcons.sale,
      MaterialCommunityIcons.account_circle,
    ];
    List<String> labelsItems = [
      'Commande',
      'Carte',
      'Vente',
      'Other',
    ];

    return AnimatedBottomNavigationBar(
      icons: iconsItems,
      activeColor: Color.fromARGB(255, 255, 255, 255),
      splashColor: Color.fromARGB(255, 218, 203, 203),
      backgroundGradient: LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ),
      inactiveColor: black.withOpacity(0.5),
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      rightCornerRadius: 10,
      activeIndex: pageIndex,
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [CommandeWidget(), CarteWidget(), VenteWidget(), OtherWidget()],
    );
  }
}
