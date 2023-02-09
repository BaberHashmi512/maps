// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class Permission extends StatefulWidget {
//   const Permission({Key? key}) : super(key: key);
//
//   @override
//   State<Permission> createState() => _PermissionState();
// }
//
// class _PermissionState extends State<Permission> {
//   Position _currentPosition;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//   _getCurrentLocation() async{
//     final Geolocator geolocator = Geolocator()
//         ..forceAndroidLocationManager= true;
//     await geolocator
//     .checkGeolocationPermissionStatus()
//     .then (GeolocationStatus status){
//       if (status == GeolocationStatus.granted){
//         geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position){
//           setState((){
//             _currentPosition = position;
//           });
//         }).catchError((e){
//           print(e);
//         });
//       } else {
//         geolocator.requestPermission().then(bool granted){
//           if (granted) {
//             geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high).then((Position position){
//                 setState((){
//                   _currentPosition = position;
//                 });
//             }).catchError((e){
//               print (e);
//             });
//           }
//         }
//       }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
