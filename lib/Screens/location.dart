import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maps/Screens/homepage.dart';
import 'package:permission_handler/permission_handler.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  void initState() {
    // TODO: implement initState
    
  }
  
bool _buttonDisabled = false;

void _onButtonPressed() {
  // Disable the button
  setState(() {
    _buttonDisabled = true;
  });

  // Set a timer to enable the button again after 3 seconds
  Timer(Duration(seconds: 3), () {
    setState(() {
      _buttonDisabled = false;
    });
  });
}

  
  Position? _currentPosition;
  String? _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        centerTitle: true,
        backgroundColor: Color(0xffA87B5D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentAddress != null) Text(_currentAddress!),
            FlatButton(
                child: Text("Get location"),
              onPressed: () async {
                PermissionStatus locationstatus = await Permission.locationWhenInUse.request();
                if(locationstatus == PermissionStatus.granted){}
                if(locationstatus == PermissionStatus.denied){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("This Permisson is Recomended")));
                }
                if(locationstatus == PermissionStatus.permanentlyDenied){
                  openAppSettings();
                }
                _getCurrentLocation();
              },
            ),
            FlatButton(onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => homepage() ),
            );
            }, 
            child: Text("Go to Home Screen"),
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
