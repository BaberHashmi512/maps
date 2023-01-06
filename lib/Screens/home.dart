// import 'dart:ffi';

// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:maps/Screens/Login.dart';
// import 'package:maps/Screens/maps.dart';
// import 'package:maps/Screens/signup.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// class home extends StatefulWidget {

  
//   const home({Key? key}) : super(key: key);
//   @override
//   State<home> createState() => _homeState();
// }
// class _homeState extends State<home> {
//   File?  _image;

//   Future getImage(ImageSource source) async {
//     try{
//     final Image =  await ImagePicker().pickImage(source: ImageSource.gallery);
//     if( Image == null ) return;
//     // final imageTemporary = File(Image.path);
//     final imagePermanent = await saveFilePermanently(Image.path);
//     setState(() {
//       this._image!= imagePermanent;
//     });
//     } on PlatformException catch (e) {
//       print('Failed to Pick Image: $e');
//     }
//   }
//   Future<File> saveFilePermanently(String imagePath) async{
//     final directory= await getApplicationDocumentsDirectory();
//     final name = basename (imagePath);
//     final Image = File('${directory.path}/$name');

//     return File(imagePath).copy(Image.path);
    
//   }
//   int myindex=0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Color(0xffA87B5D),
//             showSelectedLabels: true,
//             selectedItemColor: Colors.white,
//             iconSize: 30,
//             onTap: (index) {
//               setState(() {
//                 myindex=index;
//               });  
//             },
//             currentIndex: myindex,
//             items:[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: "Home"
//                  ),
//                  BottomNavigationBarItem(
//                 icon: Icon(Icons.location_on_outlined),
//                 label: "MAPS"
//                  ),
//             ] 
//             ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 40,),
//             _image !=null
//             ? Image.file(_image!, width: 250,height: 250,fit:BoxFit.cover,)
//             :Image.asset("assets/images/profilepic.jpeg", height: 100 ,width: 100,),

//             SizedBox(height: 30,width: 200,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Color(0xffA87B5D),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55))
//               ),
//               onPressed:()=> getImage(ImageSource.gallery),
//              child: Row(children: [
//               Icon(Icons.image_outlined),
//               Text("Pick From Gallery"),
              
//              ],),
//             ), 
//             ),
//             // CustomButton(title: 'Pick from Gallery',
//             //  icon: Icons.image_outlined,
//             //   onClick:()=> getImage(ImageSource.gallery), 
//             //   ),
//             SizedBox(height: 30,width: 200,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Color(0xffA87B5D),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55))
//               ),
//               onPressed:()=> getImage(ImageSource.camera),
//              child: Row(children: [
//               Icon(Icons.camera),
//               Text("Pick From Camera"),
//              ],),
//             ),
//             ),
//             //   CustomButton(
//             //  title: 'Pick from Camera',
//             //  icon: Icons.camera,
//             //  onClick: () => getImage(ImageSource.camera), 
//             //   ),  
//           ],
//         ),
//       ),
//     );
    
    
//   }
// }
          