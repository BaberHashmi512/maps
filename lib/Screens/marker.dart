import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as IMG;

class marker extends StatefulWidget {
  const marker({Key? key}) : super(key: key);

  @override
  State<marker> createState() => _markerState();
}

class _markerState extends State<marker> {

  getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error==>>$error");
    });
    requestLocationPermission();
    await Geolocator.getCurrentPosition().then((value) async {
      print("My Current Location");
      // print(value.latitude.toString() +
      //     "     " +
      //     value.longitude.toString());
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      setState(() {
        LatitudeAddress = value.latitude;
        longitudeAddress = value.longitude;
        // print("longitudeAddress+  " " + LatitudeAddress");
        address =
            "${placemarks.reversed.last.subLocality} ${placemarks.reversed.last.locality} ${placemarks.reversed.last.country}";
        print("address");
        print(address);
        ref.child(FirebaseAuth.instance.currentUser!.uid).update(
          {
            "location": address,
            "lat": LatitudeAddress,
            "long": longitudeAddress
          },
        ).then((value) {
          Fluttertoast.showToast(
              msg: "Location Added Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xffA87B5D),
              textColor: Colors.white,
              fontSize: 16.0);
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(
              msg: "Something went wrong try again",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      });
    });
  }

  String address = "";
  double? longitudeAddress;
  double? LatitudeAddress;

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
  }

  // Completer<GoogleMapController> _controller= Completer();
  late GoogleMapController googleMapController;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final ref = FirebaseDatabase.instance.ref("User");

  List<Marker> markers = [];
  var latitude;

  resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    IMG.Image img = IMG.decodeImage(data)!;
    IMG.Image resized = IMG.copyResize(img, width: 80, height: 80);
    resizedData = IMG.encodeJpg(resized) as Uint8List;
    return resizedData;
  }

  Hello(){
    database.ref().child('User').onValue.listen((event) {
      setState(() {
        // markers.clear();
        Map<dynamic, dynamic> markerData =
        event.snapshot.value as Map<dynamic, dynamic>;
        latitude = event.snapshot.value;
        markerData.forEach((key, value) async {
          Uint8List bytes = (await NetworkAssetBundle(Uri.parse(value["picture"])).load(value["picture"]))
              .buffer
              .asUint8List();
          bytes = resizeImage(bytes);
          markers.add(
            Marker(
              icon: BitmapDescriptor.fromBytes(bytes),
              markerId: MarkerId(key),
              position: LatLng(value["lat"], value["long"]),
              infoWindow: InfoWindow(
                title: value["firsname"],
              ),
            ),
          );
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
    Hello();

  }



  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.yellow,
      color: Colors.red,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Hello();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            body: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(30.157457, 71.524918),
                zoom: 14.4746,
              ),
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                try {
                  Position position = await _determinePosition();
                  googleMapController
                      .animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14.0,
                    ),
                  ));
                  Hello();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                }
              },
              //   Position position = await _determinePosition();
              //   googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              //       CameraPosition(
              //           target:LatLng(position.latitude, position.longitude),
              //         zoom: 14.0,
              //       ),
              //   ));
              // },
              label: const Text("Current Location"),
              icon: const Icon(Icons.location_history),
              backgroundColor: const Color(0xffA87B5D),
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission Denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location Permission are permanently Denied Please go to the Setting and turn on the Location');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.location.request();
      if (result != PermissionStatus.granted) {
        showPermissionDeniedMessage();
      }
    }
  }

  void showPermissionDeniedMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission Required"),
            content: const Text(
                "Access to device Location is necessary for the app to function properly"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("ok")),
            ],
          );
        });
  }
}
