import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:maps/Screens/Login.dart';

import 'package:maps/Screens/Splash.dart';
import 'package:maps/Screens/country_code.dart';
import 'package:maps/Screens/home.dart';
import 'package:maps/Screens/homepage.dart';
import 'package:maps/Screens/location.dart';
import 'package:maps/Screens/maps.dart';
import 'package:maps/Screens/signup.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Spalsh(),
    );
  }
}
