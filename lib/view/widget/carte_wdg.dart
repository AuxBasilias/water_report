import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_open_street_map/flutter_open_street_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// class CarteWidget extends StatefulWidget {
//   const CarteWidget({super.key});

//   @override
//   State<CarteWidget> createState() => _CarteWidget();
// }

// class _CarteWidget extends State<CarteWidget> {
//   MapController controller = MapController(
//     initMapWithUserPosition: false,
//     initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "Carte",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//       ),
//       body: OSMFlutter(
//           controller: controller,
//           trackMyPosition: true,
//           showZoomController: true,
//           initZoom: 10,
//           stepZoom: 15,
//           userLocationMarker: UserLocationMaker(
//             personMarker: MarkerIcon(
//               icon: Icon(
//                 Icons.person_pin_circle,
//                 color: Colors.blue,
//                 size: 56,
//               ),
//             ),
//             directionArrowMarker: MarkerIcon(
//               icon: Icon(
//                 Icons.person_pin_circle,
//                 color: Colors.red,
//                 size: 56,
//               ),
//             ),
//           )),
//     );
//   }
// }

class CarteWidget extends StatefulWidget {
  const CarteWidget({super.key});

  @override
  State<CarteWidget> createState() => _CarteWidgetState();
}

class _CarteWidgetState extends State<CarteWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterOpenStreetMap(
          center: LatLong(23, 89), onPicked: (pickedData) {}),
    );
  }
}
