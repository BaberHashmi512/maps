import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/main.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);
  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black38,
        body: Center(
          child: Image.asset(
            "assets/images/welcome2.png",
            // color: Colors.white,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
