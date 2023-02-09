import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController mapController;
  final Set<Marker> markers = Set();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("locations");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(event.snapshot.key),
        position: LatLng(
            event.snapshot.value["latitude"], event.snapshot.value["longitude"]),
        infoWindow: InfoWindow(title: event.snapshot.value["title"]),
      ));
    });
  }

  _onEntryChanged(Event event) {
    var markerId = markers.singleWhere((marker) => marker.markerId.value == event.snapshot.key,
        orElse: () => null);
    if (markerId != null) {
      setState(() {
        markers.remove(markerId);
        markers.add(Marker(
          markerId: markerId.markerId,
          position: LatLng(
              event.snapshot.value["latitude"], event.snapshot.value["longitude"]),
          infoWindow: InfoWindow(title: event.snapshot.value["title"]),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        markers: markers,
      ),
    );
  }
}