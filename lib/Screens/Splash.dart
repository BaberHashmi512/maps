import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/Screens/marker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? emailStored;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {



  @override
  void initState() {
    getValidation().whenComplete(
      () {
        Timer( const
          Duration(milliseconds: 55),
          () {
            Get.off(()=> emailStored == null? Login() : const HomeScreen());
          // Navigator.pushNamedAndRemoveUntil(
          //                   (context),
          //                   MaterialPageRoute(builder: (context) => emailStored== null? Login() : homepage()),
          //                   (route) => false);

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         emailStored == null ? Login() : homepage(),
            //   ),
            // );
          },
        );
      },
    );
    super.initState();
  }


   getValidation() async {
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
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
