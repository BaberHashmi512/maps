import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maps/Screens/Login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as IMG;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

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
              backgroundColor: const Color(0xffA87B5D),
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

  Future<bool>_onWillPop() async {
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

  hello() async {
    // database.ref().update(Map());
    // database.ref().child('User').onValue.forEach((element) {});
    database.ref().child('User').onValue.listen((event) {
      setState(() {
        // markers.clear();
        Map<dynamic, dynamic> markerData =
            event.snapshot.value as Map<dynamic, dynamic>;
        latitude = event.snapshot.value;
        markerData.forEach((key, value) async {
          Uint8List bytes =
              (await NetworkAssetBundle(Uri.parse(value["picture"]))
                      .load(value["picture"]))
                  .buffer
                  .asUint8List();
          bytes = resizeImage(bytes);
          markers.add(
            Marker(
              icon: BitmapDescriptor.defaultMarker,
              markerId: MarkerId(key),
              position: LatLng(value["lat"], value["long"]),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Container(
                    height: 10,
                    width: double.infinity,
                    child: Row(children: [
                      AlertDialog(
                        title: Text(value["firsname"]),
                        content: CircleAvatar(
                          backgroundImage: NetworkImage(value["picture"]),
                          maxRadius: 75,
                          minRadius: 50,
                        ),
                      ),
                    ]),
                  ),
                );
              },
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
    hello();
    getConnectivity();
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
        await hello();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            body:
              // StreamView(Stream.fromFuture(hello())),
                // if (!snapshot.hasData || snapshot.data == null) {
                //   return const CircularProgressIndicator();
                // }
                // Map<String,dynamic> userData = snapshot.data!.snapshot.value;
                // List<Marker> newMarkers = [];
                // userData.forEach((key, value) {
                //   double latitude = value["lat"];
                //   double longitude = value["long"];
                //   String userName = value["firsname"];
                //   Marker newMarker = Marker(
                //     markerId: MarkerId(key),
                //     position: LatLng(latitude, longitude),
                //     infoWindow: InfoWindow(title: userName ),
                //   );
                //   newMarkers.add(newMarker);
                // });
                GoogleMap(
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
            floatingActionButton: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(bottom: 518, right: 10),
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Logout"),
                                    content: const Text(
                                      "Do you really want to Log out?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.greenAccent),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (BuildContext
                                            //                 context) =>
                                            //             Login()));
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()),
                                                (route) => false);
                                            // Get.to(() => Login());
                                          },
                                          child: const Text(
                                            "Logout",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent),
                                          )),
                                    ],
                                  ));
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(left: 60, top: 50),
                            child: Container(
                                color: Colors.red,
                                child: const Icon(
                                  Icons.exit_to_app,
                                  size: 40,
                                  color: Colors.white,
                                )),
                        ))),
                Container(
                  width: 120,
                  height: 160,
                  padding:
                      const EdgeInsets.only(bottom: 100, left: 90, top: 10),
                  child: FloatingActionButton(
                    child: const Icon(Icons.gps_fixed),
                    onPressed: () async {
                      try {
                        Position position = await _determinePosition();
                        googleMapController
                            .animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 14.0,
                          ),
                        ));
                        await hello();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    },
                    // label: const Text("Current Location"),
                    // icon: const Icon(Icons.calculate),
                    // backgroundColor: const Color(0xffA87B5D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _determinePosition() async {
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

  requestLocationPermission() async {
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

  showDialogBox() => showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("No Connection"),
            content: const Text("Please Check your Internet Connection"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialogBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text("OK"),
              )
            ],
          ));
}
