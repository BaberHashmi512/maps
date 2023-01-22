import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/Screens/homepage.dart';
import 'package:maps/Screens/sadam.dart';
import 'package:maps/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? emailStored;

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);
  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  void initState() {
    getValidation().whenComplete(
      () {
        Timer( const
          Duration(seconds: 1),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    emailStored == null ? Login() : homepage(),
              ),
            );
          },
        );
      },
    );
    super.initState();
  }

  Future getValidation() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var getemail = sharedPreferences.getString('email');
    setState(() {
      emailStored = getemail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffA87B5D),
        body: Center(
          child: Image.asset(
            "assets/images/welcome6.png", height: 355, width: 355,
            // color: Colors.white,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
