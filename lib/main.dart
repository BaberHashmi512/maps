import 'package:flutter/material.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/Screens/Signup.dart';
import 'package:maps/Screens/Splash.dart';
import 'package:maps/Screens/country_code.dart';
import 'package:maps/Screens/home.dart';
import 'package:maps/Screens/maps.dart';

void main() {
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
      home: home(),
    );
  }
}
