import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final String busId;
  final bool isDriver;

  const MapScreen({
    Key? key,
    required this.busId,
    required this.isDriver,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var res = FirebaseFirestore.instance.collection('bus_data');
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  StreamSubscription<LocationData>? locationSubscription;

  final LatLng _lastMapPosition = LatLng(30.6815, 73.0895);
  List<LatLng> S2S = [];
  var docId;
  int lattie = 5;

  void _onAddMarkerButtonPressed() async {
    await FirebaseFirestore.instance
        .collection('bus_data')
        .where('bus_id', isEqualTo: widget.busId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          docId = doc.id;
        });

        doc['bus_routes']
            .map((e) =>
        {
          setState(() {
            S2S.add(LatLng(e['lat'], e['lng']));
          })
        })
            .toList();
      });
    });

    S2S
        .map((e) =>
    {
      _markers.add(Marker(
        markerId: MarkerId(S2S.indexOf(e).toString()),
        position: e,
        icon: BitmapDescriptor.defaultMarker,
      ))
    })
        .toList();

    setState(() {
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        points: S2S,
        color: Colors.blue,
        width: 3,
      ));
    });
  }

  fetchLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      print('location changed called');
      res.doc(docId).update(
          {'lat': currentLocation.latitude, 'lng': currentLocation.longitude});
      updateMarkers(
          currentLocation.latitude, currentLocation.longitude);
    });
  }

  updateMarkers(double? lat, double? lng) async {
    if (S2S.isNotEmpty) {
      List<LatLng> newArray = [];
      newArray.addAll(S2S);
      print('newArray $newArray');
      newArray.removeAt(0);
      setState(() {
        S2S.clear();
        S2S.add(LatLng(lat as double, lng as double));
        S2S.addAll(newArray);
        _markers.add(Marker(
          markerId: MarkerId(0.toString()),
          position: S2S.elementAt(0),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isDriver) {
      fetchLocation();
    } else {
      Timer.periodic(new Duration(seconds: 10), (timer) async {
        await FirebaseFirestore.instance
            .collection('bus_data')
            .where('bus_id', isEqualTo: widget.busId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            updateMarkers(doc['lat'], doc['lng']);
          });
        });
      });
    }
  }

  @override
  void dispose() {
    print('dispose called');
    locationSubscription?.cancel();
    super.dispose();
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
        body: SafeArea(
            child: GoogleMap(
              polylines: _polyline,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _onAddMarkerButtonPressed();
                // Timer.periodic(new Duration(seconds: 10), (timer) {
                //   print('after 10 second called');
                //   S2S.clear();
                //   _markers.clear();
                //   _polyline.clear();
                //   _onAddMarkerButtonPressed();
                // });
              },

              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _lastMapPosition,
                zoom: 11.0,
              ),
              mapType: MapType.normal,
            )));
  }
}
