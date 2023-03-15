// import 'dart:io';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
//
//
// class Uploadimage extends StatefulWidget {
//   const Uploadimage({Key? key}) : super(key: key);
//
//   @override
//   State<Uploadimage> createState() => _UploadimageState();
// }
//
// class _UploadimageState extends State<Uploadimage> {
//   bool loading = false;
//   File? _image;
//   final picker= ImagePicker();
//   firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;
//   DatabaseReference databaseRef= FirebaseDatabase.instance.ref('User');
//   Future getImageGallery() async{
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality:80);
//     setState(() {
//       if(pickedFile !=null){
//         _image = File(pickedFile.path);
//       }else{
//         print('no image picked');
//       }
//     });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("UploadIMage"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: InkWell(
//               onTap: (){
//                 getImageGallery();
//               } ,
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black,
//                   )
//                 ),
//                 child: _image !=null? Image.file(_image!.absolute):
//                 Center(child: Icon(Icons.image)),
//               ),
//             ),
//           ),
//           SizedBox(height: 40,),
//           ElevatedButton(
//              onPressed: ()async{
//             setState(() {
//               loading = true;
//             });
//             firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername'+DateTime.now().millisecondsSinceEpoch.toString());
//             firebase_storage.UploadTask uploadTask= ref.putFile(_image!.absolute);
//
//              Future.value(uploadTask).then((value) async{
//               var newurl = await ref.getDownloadURL();
//
//               databaseRef.child('1').set({
//                 'id': '1212',
//                 'title': newurl.toString()
//               });
//             }).onError((error, stackTrace){
//             });
//
//           },
//               child: Text("Upload Image"),
//
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerInfoWindow extends StatefulWidget {
  const CustomMarkerInfoWindow({Key? key}) : super(key: key);

  @override
  State<CustomMarkerInfoWindow> createState() => _CustomMarkerInfoWindowState();
}

class _CustomMarkerInfoWindowState extends State<CustomMarkerInfoWindow> {

  CustomInfoWindowController _customInfoWindowController=
  CustomInfoWindowController();

  final List<Marker> _markers= <Marker>[];
  final List<LatLng> _latLang= [
    LatLng(33.6941,72.9734), LatLng(33.7008,72.9682),LatLng(33.6992, 72.9744),
    LatLng(33.6939,72.9771), LatLng(33.6910, 72.9807),LatLng(33.7036,72.9785)
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  loadData(){
    for(int i =0 ; i<_latLang.length ; i++){
      if (i%2 == 0){
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            icon:BitmapDescriptor.defaultMarker,
            position: _latLang[i],
            onTap: (){
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: CircleAvatar(radius: 30, backgroundColor: Colors.blue,)
                      ,
                    ),
                  ),
                  _latLang[i]
              );
            }
        ),
        );
      }else{
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            icon:BitmapDescriptor.defaultMarker,
            position: _latLang[i],
            onTap: (){
              _customInfoWindowController.addInfoWindow!(
                  Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 300,
                          height: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/login5.png"),
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.high),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text("Beef Tacos",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                              Spacer(),
                              Text(".3 mi")
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10,right: 10),
                          child: Text(
                            " Help me Finish this Tacos! i Bought a Complete Platter but I don't have Power to finish it Please help me Out",
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  _latLang[i]
              );
            }
        ),
        );
      }

      setState(() {

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Info Window"),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(33.6941,72.9734),
                zoom: 14,
              ),
          markers: Set<Marker>.of(_markers),
            onTap: (postition){
                _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position){
                _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller){
                _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(controller: _customInfoWindowController,
          height: 200,
            width: 300,
            offset: 35,
          )
        ],
      ),
    );
  }
}
