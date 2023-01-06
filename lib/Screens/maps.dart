import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/Screens/User_Model.dart';
import 'package:maps/main.dart';


void main() {
  runApp(MyApp());
}

class maps extends StatefulWidget {
  const maps({Key? key}) : super(key: key);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  User? user= FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

 @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection("User")
    .doc(user!.uid)
    .get()
    .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text("${loggedInUser.firstname} ${loggedInUser.lastname}",
            style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("${loggedInUser.email}"),
            leading: Icon(Icons.person),
            trailing: Icon(Icons.star),
          ),
          ListTile(
            title: Text("Baber Ali Hashmi",style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("Timber Market Daira Basti, Hashmi House Multan"),
            leading: Icon(CupertinoIcons.profile_circled),
            trailing: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}