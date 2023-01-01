import 'dart:html';
import 'dart:js';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/Screens/maps.dart';
import 'package:image_picker/image_picker.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
  PickedFile _imageFile;
  final ImagePicker _picker= ImagePicker();
  int myindex=0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageprofile(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xffA87B5D),
          showSelectedLabels: true,
          selectedItemColor: Colors.white,
          iconSize: 30,
          onTap: (index) {
            setState(() {
              myindex=index;
            });  
          },
          currentIndex: myindex,
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
               ),
               BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: "MAPS"
               ),
          ] 
          ),
          // body: IndexedStack(
          //   children: widgetList,
          //   index: myindex,
          // ),
    ),
    );
  }
Widget imageprofile(){
  return Center(
    child: Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile==null
          ? AssetImage("assets/images/Baber.photho.jpg")
          :FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: (){
              // showModalBottomSheet(
              //   // context : context,
              //   builder: ((builder)=> bottomsheet()),
              // );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]
    ),
  );
}
Widget bottomsheet(){
  return Container(
    height: 100.0,
    width: 100.0,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: [
        Text("Choose Profile Photo",
        style: TextStyle(
          fontSize: 20.0,
        ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(icon: Icon(Icons.camera),
            onPressed: (){
              takePhotho(CanvasImageSource.camera);
            },
            label: Text("Camera"),
            ),
            FlatButton.icon(icon: Icon(Icons.image),
            onPressed: (){},
            
            label: Text("Gallery"),
            ),

          ],
        )
      ],
    ),
  );
}
void takePhotho(CanvasImageSource source) async{
  final PickedFile = await _picker.getImage(
    source:source,
  );
  SetState((){
    _imageFile= pickedFile;
  });
}