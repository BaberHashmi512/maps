import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class marker extends StatefulWidget {
const marker({Key? key}) : super(key: key);

@override
_markerState createState() => _markerState();
}

class _markerState extends State<marker> {
  final dbRef = FirebaseDatabase.instance.ref("User");
Completer<GoogleMapController> _controller = Completer();
static final CameraPosition _kGoogle = const CameraPosition(
	target: LatLng(20.42796133580664, 80.885749655962),
	zoom: 14.4746,
);
final List<Marker> _markers = <Marker>[
	Marker(
		markerId: MarkerId('1'),
	position: LatLng(20.42796133580664, 75.885749655962),
	infoWindow: InfoWindow(
		title: 'My Position',
	)
),

Marker(
		markerId: MarkerId('5'),
	position: LatLng(20.42796133580656, 75.885749655956),
	infoWindow: InfoWindow(
		title: 'My Position 5',
	)
),
];
Future<Position> getUserCurrentLocation() async {
	await Geolocator.requestPermission().then((value){
	}).onError((error, stackTrace) async {
	await Geolocator.requestPermission();
	print("ERROR"+error.toString());
	});
	return await Geolocator.getCurrentPosition();
}

@override
Widget build(BuildContext context) {
	return Scaffold(
	body: Container(
		child: SafeArea(
		child: GoogleMap(
		initialCameraPosition: _kGoogle,
	
		markers: Set<Marker>.of(_markers),
		mapType: MapType.normal,
		myLocationEnabled: true,
		compassEnabled: true,
		onMapCreated: (GoogleMapController controller){
				_controller.complete(controller);
        
			},
		),
		),
	),
	floatingActionButton: FloatingActionButton(
		onPressed: () async{
		getUserCurrentLocation().then((value) async {
			print(value.latitude.toString() +" "+value.longitude.toString());
			_markers.add(
				Marker(
				markerId:  MarkerId("2"),
				position: LatLng(value.latitude, value.longitude),
				infoWindow: InfoWindow(
					title: 'Baber Ali',
				),
				),
			);
      _markers.add(
				Marker(
				markerId: MarkerId("5"),
				position: LatLng(24.9004032,67.190784),
				infoWindow: InfoWindow(
					title: 'Qalandar',
				),
				),
			);
			CameraPosition cameraPosition = new CameraPosition(
			target: LatLng(value.latitude, value.longitude),
			zoom: 14,
			);
			final GoogleMapController controller = await _controller.future;
			controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
			setState(() {
			});
		});
		},
		child: Icon(Icons.local_activity),
	),
	);
}
}
