import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  static final CameraPosition _ToTheSahiwal = CameraPosition(
    target: LatLng(30.666121, 73.102013),
    zoom: 14.4746,
  );

  static final Marker _ToTheSahiwalMarker = Marker(
    markerId: MarkerId('_ToTheSahiwal'),
    infoWindow: InfoWindow(title: 'Sahiwal'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(30.666121, 73.102013),
  );

  static final CameraPosition _currentLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(30.69130627971729, 73.09720280489398),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Marker _currentLocationMarker = Marker(
    markerId: MarkerId('_currentLocation'),
    infoWindow: InfoWindow(title: 'My Location'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(30.69130627971729, 73.09720280489398),
  );

  static final Polyline _polyLine = Polyline(
    polylineId: PolylineId('_polyLine'),
    points: [
      LatLng(30.666121, 73.102013),
      LatLng(30.69130627971729, 73.09720280489398),
    ],
    width: 3,
  );

  static final Polygon _polyGon = Polygon(
    polygonId: PolygonId('_polyGon'),
    points: [
      LatLng(30.69130627971729, 73.09720280489398),
      LatLng(30.666121, 73.102013),
      LatLng(30.6461, 73.0810),
      LatLng(30.6703, 73.0750),
    ],
    strokeWidth: 3,
    fillColor: Colors.transparent,
  );

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'Google Map',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToMyLocation,
          label: Text('My Location'),
          icon: Icon(Icons.person),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          polylines: {
            _polyLine,
          },
          polygons: {
            _polyGon,
          },
          markers: {_ToTheSahiwalMarker, _currentLocationMarker},
          initialCameraPosition: _ToTheSahiwal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
  }
}
