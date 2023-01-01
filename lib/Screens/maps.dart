import 'dart:html';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:maps/main.dart';
void main() {
  runApp(MyApp());
}
class maps extends StatefulWidget {
  @override
  State<maps> createState() => _mapsState();
}
class _mapsState extends State<maps> {
  final geolocator=  Geolocator.getCurrentPosition(forceAndroidLocationMangaer:true);
  Position _currentPosition;
  String currentAddress="";

  void getCurrentLocation(){
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    .then ((Position position) {
      setState(() {
        _currentPosition= position;
      });
      getAddressFromLatlng();
    }).catchError((e){
      print(e);
    });
    }
    void getAddressFromLatlng() async{
      try{
        List<Placemark> P = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
          Placemark place = P[0];
          setState(() {
            currentAddress=
            "${place.thoroughfare},${place.subThoroughfare},${place.name},${place.Locality}";
          });
      }
      catch (e) {
        print(e);
      }
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Location"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              padding: EdgeInsets.symmetric(horizontal:16, vertical:16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text('Get Location', style: Theme.of(context).textTheme.caption),
                              onPressed: getCurrentLocation,
                            ),
                      if (_currentPosition !=null &&
                          currentAddress !=null)
                          Text(currentAddress, style: TextStyle(fontSize: 20.0),)
                          else
                          Text("Could'not fetch the")
                          ],
                          ),
                        ),
                    SizedBox(width: 8,),
                    ],
                  )
              ]),
            ),
          ],
        ),
        ),
    );
  }
}