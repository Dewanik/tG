import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

final StateNotifierProvider<MarkAdder, List<Marker>> markerProvider = StateNotifierProvider<MarkAdder, List<Marker>>((ref) {
  return MarkAdder();
});

class MarkAdder extends StateNotifier<List<Marker>> {
  MarkAdder() : super([]);

  void handleTap(TapPosition tapPosition, LatLng pointD) {
    state = [
      ...state,
      Marker(
        point: pointD,
        width: 40,
        height: 40,
        child:_buildMarker(pointD),
      ),
    ];
  }

  void clearMarkers() {
    state = [];
  }

  void removeMarker(LatLng pointD) {
    state = state.where((marker) => marker.point != pointD).toList();
  }

  Widget _buildMarker(LatLng pointD) {
    return GestureDetector(
      onTap: () => removeMarker(pointD),
      child: MouseRegion(
        onEnter: (_) => _onMarkerHover(pointD),
        onExit: (_) => _onMarkerHoverExit(pointD),
        child: Stack(
          children: [
            Icon(Icons.location_pin, color: Colors.red, size: 40),
            Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _onMarkerHover(LatLng pointD) {
    // Handle hover event to show cross icon or label
  }

  void _onMarkerHoverExit(LatLng pointD) {
    // Handle hover exit event to hide cross icon or label
  }

void addInitialMarkers({List<LatLng>? points}) {
    state = points?.map((point) {
      return Marker(
        point: point,
        width: 40,
        height: 40,
        child:  _buildMarker(point),
      );
    }).toList() ?? [];
    
  }
  
}
class TGMaps extends ConsumerStatefulWidget {
  final List<LatLng>? initialMarkers;

  TGMaps({super.key, this.initialMarkers});
  

  @override
  _TGMapsState createState() => _TGMapsState();
}

class _TGMapsState extends ConsumerState<TGMaps> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng? _initialCenter;
  
  
  
  get initialMarkers => widget.initialMarkers;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    
  }

  Future<void> _fetchCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
    setState(() {
      _initialCenter = LatLng(_locationData.latitude!, _locationData.longitude!);
      _mapController.move(_initialCenter!, 15.0);
    });
    print(LatLng(_locationData.latitude!, _locationData.longitude!));
    ref.watch(markerProvider.notifier).addInitialMarkers(points: initialMarkers);
  }

  @override
  Widget build(BuildContext context) {
    final markers = ref.watch(markerProvider);
    
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter ?? LatLng(28, 29),
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
        onTap: (tapPosition, point) {
          ref.read(markerProvider.notifier).handleTap(tapPosition, point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
