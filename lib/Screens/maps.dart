import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MyApp());
// }
// class maps extends StatefulWidget {
//   const maps({Key? key}) : super(key: key);

//   @override
//   State<maps> createState() => _mapsState();
// }

// class _mapsState extends State<maps> {
//   final dbRef = FirebaseDatabase.instance.ref("User");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  FirebaseAnimatedList(
//                   query: dbRef,
//                   itemBuilder: (context, snapshot, animation, index) {
//                     return LocationPage();
//                   }
//             ),
//           );
//   }
// }

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController _controller;
  Position _currentPosition = Position(longitude: 24.9004032, latitude: 67.190784, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId("current_location"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: "Your Location",
            snippet:
                "Latitude: ${position.latitude}, Longitude: ${position.longitude}",
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
    
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 14.4746,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
          _controller = controller;
              },
            
    );
  }
}