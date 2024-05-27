import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class TGMaps extends StatefulWidget {
 @override
  TGMapsState createState() => TGMapsState();
}

class TGMapsState extends State<TGMaps>{

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
    mapController: MapController(),
    options: MapOptions(),
    children: [TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  
  // Plenty of other options available!
),],
);
  }
}