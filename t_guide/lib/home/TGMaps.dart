import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart' as l1;


class TGMaps extends StatefulWidget {
  final  initial_loc;
  const TGMaps( {super.key, required this.initial_loc});
  
  
 

  
 @override
  TGMapsState createState() => TGMapsState();
}

class TGMapsState extends State<TGMaps>{
  var location;
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location = widget.initial_loc;
  }
  void handleTap(tapP, point){
    print("Works");
    print(location);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:FlutterMap(
    mapController: MapController(),
    options: MapOptions(
      
      onTap: (tapPosition, point) => handleTap(tapPosition, point
      
      )),
    children: [TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  
  // Plenty of other options available!
),],
),

 ); }
}