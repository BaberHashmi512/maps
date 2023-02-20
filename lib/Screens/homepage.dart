import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/Screens/ImagePicke.dart';
import 'package:maps/Screens/marker.dart';
import 'package:permission_handler/permission_handler.dart';


enum MediaType {
  image,
  video;
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  Future<bool> _onWillPop() async{
    SystemNavigator.pop();
    return false;
  }
  final ref = FirebaseDatabase.instance.ref("User");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
  }
  int _selectedIndex = 0;
  // static const List<Widget> _widgetOptions = <Widget> [
  //   ImagePick(),
  //   marker(),
  // ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error==>>" + error.toString());
    });
    requestLocationPermission();
     await Geolocator.getCurrentPosition().then((value) async {
            print("My Current Location");
            // print(value.latitude.toString() +
            //     "     " +
            //     value.longitude.toString());
            List<Placemark> placemarks =
                await placemarkFromCoordinates(value.latitude, value.longitude);
            setState(() {
              LatitudeAddress = value.latitude;
              longitudeAddress = value.longitude;
              // print("longitudeAddress+  " " + LatitudeAddress");
              address = placemarks.reversed.last.subLocality.toString()+
                  " " +
                  placemarks.reversed.last.locality.toString() +
                  " " +
                  placemarks.reversed.last.country.toString();
                  print("address");
                  print(address);
                  ref.child(FirebaseAuth.instance.currentUser!.uid).update(
                    {"location": address, "lat": LatitudeAddress, "long": longitudeAddress},
                  ).then((value) {
                    Fluttertoast.showToast(
                        msg: "Location Added Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xffA87B5D),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(
                        msg: "Something went wrong try again",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
});
            });
            }
  String address = "";
  double? longitudeAddress;
  double? LatitudeAddress;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(

          // bottomNavigationBar: BottomNavigationBar(
          //     type: BottomNavigationBarType.fixed,
          //     backgroundColor: Color(0xffA87B5D),
          //     showSelectedLabels: true,
          //     selectedItemColor: Colors.white,
          //     iconSize: 30,
          //     onTap: _onItemTapped,
          //     currentIndex: _selectedIndex,
          //     items: [
          //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.location_on_outlined), label: "MAPS"),
          //     ]),
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   elevation: 0,
          //   centerTitle: true,
          //   title: const Text(
          //     "User Profile And Portfolio",
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          //   ),
          //   backgroundColor: Color(0xffA87B5D),
          // ),
          // body: _widgetOptions.elementAt(_selectedIndex)
      ),
    );
  }
  Future<void> requestLocationPermission()async{
    final status = await Permission.location.status;
    if (status != PermissionStatus.granted){
      final result = await Permission.location.request();
      if(result != PermissionStatus.granted){
        showPermissionDeniedMessage();
      }
    }
  }
  void showPermissionDeniedMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Permission Required"),
            content: Text("Acces to device Location is necessary for the app to function properly"),
            actions: [
              ElevatedButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("ok")),
            ],
          );
        }
    );
  }
}
// Widget CustomButton({
//   required String title,
//   required IconData icon,
//   required VoidCallback onClick,
// }){
//   return Container(
//     width: 280,
//     child: ElevatedButton(
//       onPressed: () => {}, 
//       child: Row(
//         children: [
//           Icon(icon),
//           SizedBox(width: 20,),
//           Text(title)
//         ],
//       ),
//       ),
//   );
// }

// //  Widget bottomSheet(BuildContext context) {
// //   Size size = MediaQuery.of(context).size;
// //   return Container(
// //     width: double.infinity,
// //     height: size.height*0.2,
// //     margin: EdgeInsets.symmetric(
// //       vertical: 20,
// //       horizontal: 10,
// //     ),
// //     child: Column(
// //       children: [
// //         const Text("Choose Profile Photho",
// //         style: TextStyle(
// //           fontSize: 20.0,
// //           fontWeight: FontWeight.bold,
// //         ),),
// //         const SizedBox(height: 20.0,),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             InkWell(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: const[
// //                   Icon(Icons.image,
// //                   color: Colors.purple,
// //                   ),
// //                   SizedBox(
// //                     height: 5,
// //                   ),
// //                   Text("Gallery",
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.purple,
// //                   ),
// //                   ),
// //                 ],
// //               ),
// //               onTap: (){
// //                 takePhotho(ImageSource.gallery);
// //               },
// //             ),
// //             const SizedBox(width: 80,),
// //             InkWell(
// //               child: Column(
// //                 children: const [
// //                   Icon(Icons.camera,
// //                   color: Colors.deepPurple,
// //                   ),
// //                   SizedBox(
// //                     height: 5,
// //                   ),
// //                   Text("Camera",
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.deepPurple,
// //                   ),
// //                   ),
// //                 ],
// //               ),
// //               onTap:  (){
// //                 takePhotho(ImageSource.camera);
// //               },
// //             ),
// //           ],
// //         )
// //       ],
// //     ),
// //   );
// //  }
 
// //   void takePhotho(ImageSource source) {
// //     final pickedImage = 
// //     await imagePicker.pickImage(source: source, imageQuality: 100);
// //     pickedFile = File (pickedImage!.path);
// //     // print(pickedFile);

// //   }
// // }


// // Widget imageprofile(){
// //   return Center(
// //     child: Stack(
// //       children: [
// //         CircleAvatar(
// //           radius: 80.0,
          
// //           backgroundImage: _imageFile==null
// //           ?? AssetImage("assets/images/Baber.photho.jpg")
// //           :FileImage(File(_imageFile.path)),
// //         ),
// //         Positioned(
// //           bottom: 20.0,
// //           right: 20.0,
// //           child: InkWell(
// //             onTap: (){
// //               // showModalBottomSheet(
// //               //   // context : context,
// //               //   builder: ((builder)=> bottomsheet()),
// //               // );
// //             },
// //             child: Icon(
// //               Icons.camera_alt,
// //               color: Colors.teal,
// //               size: 28.0,
// //             ),
// //           ),
// //         ),
// //       ]
// //     ),
// //   );
// // }
// // Widget bottomsheet(){
// //   return Container(
// //     height: 100.0,
// //     width: 100.0,
// //     margin: EdgeInsets.symmetric(
// //       horizontal: 20,
// //       vertical: 20,
// //     ),
// //     child: Column(
// //       children: [
// //         Text("Choose Profile Photo",
// //         style: TextStyle(
// //           fontSize: 20.0,
// //         ),
// //         ),
// //         SizedBox(
// //           height: 20.0,
// //         ),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             FlatButton.icon(icon: Icon(Icons.camera),
// //             onPressed: (){
// //               takePhotho(ImageSource.camera);
// //             },
// //             label: Text("Camera"),
// //             ),
// //             FlatButton.icon(icon: Icon(Icons.image),
// //             onPressed: (){},
            
// //             label: Text("Gallery"),
// //             ),

// //           ],
// //         )
// //       ],
// //     ),
// //   );
// // }
// // void takePhotho(CanvasImageSource source) async{
// //   final PickedFile = await _picker.getImage(
// //     source:source,
// //   );
// //   SetState((){
// //     _imageFile= pickedFile;
// //   });
// // }
// // return Stack(
//     //   alignment: Alignment.center,
//     //   children: [
//     //     CircleAvatar(
//     //       backgroundImage: AssetImage("assets/images/profilepic.jpeg"),
//     //       radius: 55,
//     //     ),
//     //     Positioned(
//     //       bottom: 5,
//     //       child: InkWell(
//     //         child: Icon(Icons.camera),
//     //         onTap: (){
//     //           print("Camera Clicked");
//     //           showModalBottomSheet(context: context, builder:(context) => bottomSheet() );
//     //         },
//     //       ),
//     //       ),
//     //   ],
//       // child: SafeArea(
//       //   child: Scaffold(
//       //     body: Column(
//       //       mainAxisAlignment: MainAxisAlignment.start,
//       //       children: [
              
//       //         SizedBox(
//       //           height: 20,
//       //         ),
//       //       ],
//       //     ),