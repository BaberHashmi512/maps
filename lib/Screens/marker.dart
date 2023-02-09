// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class marker extends StatefulWidget {
// const marker({Key? key}) : super(key: key);
//
// @override
// _markerState createState() => _markerState();
// }
// class _markerState extends State<marker> {
// 	final dbRef = FirebaseDatabase.instance.ref("User");
// 	Completer<GoogleMapController> _controller = Completer();
// 	static final CameraPosition _kGoogle = const CameraPosition(
// 		target: LatLng(20.42796133580664, 80.885749655962),
// 		zoom: 14.4746,
// 	);
// 	final List<Marker> _markers = <Marker>[
// 		Marker(
// 				markerId: MarkerId('1'),
// 				position: LatLng(20.42796133580664, 75.885749655962),
// 				infoWindow: InfoWindow(
// 					title: 'My Position',
// 				)
// 		),
// 		Marker(
// 				markerId: MarkerId('5'),
// 				position: LatLng(20.42796133580656, 75.885749655956),
// 				infoWindow: InfoWindow(
// 					title: 'My Position 5',
// 				)
// 		),
// 	];
//
// 	Future<Position> getUserCurrentLocation() async {
// 		await Geolocator.requestPermission().then((value) {}).onError((error,
// 				stackTrace) async {
// 			await Geolocator.requestPermission();
// 			print("ERROR" + error.toString());
// 		});
// 		return await Geolocator.getCurrentPosition();
// 	}
//
// 	@override
// 	Widget build(BuildContext context) {
// 		return Scaffold(
// 				body: Container(
// 					child: SafeArea(
// 						child: GoogleMap(
// 							initialCameraPosition: _kGoogle,
// 							markers: Set<Marker>.of(_markers),
// 							mapType: MapType.normal,
// 							myLocationEnabled: true,
// 							compassEnabled: true,
// 							onMapCreated: (GoogleMapController controller) {
// 								_controller.complete(controller);
// 							},
// 						),
// 					),
// 				),
// 				floatingActionButton: FloatingActionButton(
// 					onPressed: () async {
// 						getUserCurrentLocation().then((value) async {
// 							print(
// 									value.latitude.toString() + " " + value.longitude.toString());
// 							_markers.add(
// 								Marker(
// 									markerId: MarkerId("2"),
// 									position: LatLng(value.latitude, value.longitude),
// 									infoWindow: InfoWindow(
// 										title: 'Baber Ali',
// 									),
// 								),
// 							);
// 							_markers.add(
// 								Marker(
// 									markerId: MarkerId("5"),
// 									position: LatLng(24.9004032, 67.190784),
// 									infoWindow: InfoWindow(
// 										title: 'Qalandar',
// 									),
// 								),
// 							);
// 							CameraPosition cameraPosition = new CameraPosition(
// 								target: LatLng(value.latitude, value.longitude),
// 								zoom: 14,
// 							);
// 							final GoogleMapController controller = await _controller.future;
// 							controller.animateCamera(
// 									CameraUpdate.newCameraPosition(cameraPosition));
// 							setState(() {});
// 						});
// 					},
// 					child: Icon(Icons.local_activity),
// 				)
// 		);
// 	}
// }


// ........................

// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// class marker extends StatefulWidget {
//   const marker({Key? key}) : super(key: key);
//
//   @override
//   State<marker> createState() => _markerState();
// }

// class _markerState extends State<marker> {
// 	final aut = FirebaseAuth.instance;
// 	final ref= FirebaseDatabase.instance.ref("User");
//   final Completer<GoogleMapController> _controller= Completer();
//   static const CameraPosition _kGooglePlex= CameraPosition(target: LatLng(33.6844, 73.479),
//   zoom: 14, );
//   final List<Marker> _markers= const <Marker>[
//     Marker(markerId: MarkerId('1'),
//     position: LatLng(33.6844, 73.479),
//       infoWindow: InfoWindow(title: "Baber Ali Hashmi")
//     ),
//   ];
//   var latitude;
//   var longitude;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//               child: FirebaseAnimatedList(
//                   query: ref,
//                   defaultChild: Text('Loading'),
//                   itemBuilder: (Context, snapshot, animation, indexs){
//                     latitude = snapshot.child('lat').value;
//                     longitude= snapshot.child('long').value;
//                     return GoogleMap(
//                       onCameraMove: (CameraPosition position){
//                         latitude= position.target.latitude.toString();
//                         longitude= position.target.longitude.toString();
//                       },
//                         initialCameraPosition: _kGooglePlex,
//                       markers: Set<Marker>.of(_markers),
//                       onMapCreated: (GoogleMapController controller){
//                         _controller.complete(controller);
//                       },
//
//                     );
//
//
//                   }
//               ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/*import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class marker extends StatefulWidget {
  const marker({Key? key}) : super(key: key);

  @override
  State<marker> createState() => _markerState();
}

class _markerState extends State<marker> {
  GoogleMapController? mycontroller;
  Map<MarkerId, Marker> markers = <MarkerId , Marker>{};

  void initMarker(specify, specifyId)async{
    var markerIdval= specifyId;
    final MarkerId markerId= MarkerId(markerIdval);
    final Marker marker= Marker(
        markerId: markerId,
      position: LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: 'Users', snippet: specify['address'])
    );
    setState(() {
      markers[markerId]= marker;
    });
  }

  getMarkerData()async{
    FirebaseDatabase.instance.ref().child('User').once().then((myMockData)
    {
      if(myMockData.documents.isNotEmpty){
        for(int i=0; i<myMockData.documents.length; i++){
       initMarker(myMockData.documents[i].data, myMockData.documents[i].documentID);
        }
      }
    });
  }
  void initstate(){
    getMarkerData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker(){
      return <Marker>[
         Marker(
            markerId: MarkerId('Code Base'),
          position: LatLng(33.6844, 73.479),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Office')
        )
      ].toSet();
    }
    return Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values),
          mapType: MapType.normal,
          initialCameraPosition:CameraPosition(
              target:LatLng(33.6844, 73.479),
            zoom: 14.0,),
        onMapCreated: (GoogleMapController controller){
            mycontroller= controller;
        },
      ),
    );
  }
}/

// ..... tutorial code Ended

//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class MyMap extends StatefulWidget {
//   @override
//   _MyMapState createState() => _MyMapState();
// }
//
// class _MyMapState extends State<MyMap> {
//   GoogleMapController? mapController;
//   final Set<Marker> markers = Set();
//   final FirebaseDatabase database = FirebaseDatabase.instance;
//   DatabaseReference?  databaseReference;
//   @override
//   void initState() {
//     super.initState();
//     databaseReference = database.ref().child("User");
//     databaseReference?.onChildAdded.listen(_onEntryAdded);
//     databaseReference?.onChildChanged.listen(_onEntryChanged);
//   }
//
//   _onEntryAdded( event) {
//     setState(() {
//       markers.add(Marker(
//         markerId: MarkerId(event.snapshot.key),
//         position: LatLng(
//             event.snapshot.value["latitude"], event.snapshot.value["longitude"]),
//         infoWindow: InfoWindow(title: event.snapshot.value["title"]),
//       ));
//     });
//   }
//
//   _onEntryChanged(event) {
//     var markerId = markers.singleWhere((marker) => marker.markerId.value == event.snapshot.key,
//         orElse: () => null);
//     if (markerId != null) {
//       setState(() {
//         markers.remove(markerId);
//         markers.add(Marker(
//           markerId: markerId.markerId,
//           position: LatLng(
//               event.snapshot.value["latitude"], event.snapshot.value["longitude"]),
//           infoWindow: InfoWindow(title: event.snapshot.value["title"]),
//         ));
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         onMapCreated: (controller) {
//           setState(() {
//             mapController = controller;
//           });
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.42796133580664, -122.085749655962),
//           zoom: 14.4746,
//         ),
//         markers: markers,
//       ),
//     );
//   }
// }
 */
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class marker extends StatefulWidget {
  const marker({Key? key}) : super(key: key);

  @override
  State<marker> createState() => _markerState();
}

class _markerState extends State<marker> {
  final FirebaseDatabase database= FirebaseDatabase.instance;
  List<Marker> markers= [];

  var latitude;


  @override
  void initState(){
    super.initState();
    database.ref().child('User').onValue.listen((event) {
      setState(() {
        // markers.clear();
        Map<dynamic,dynamic> markerData = event.snapshot.value as Map<dynamic,dynamic>;
        latitude = event.snapshot.value;
        markerData.forEach((key, value) {
          markers.add(
            Marker(
                markerId: MarkerId(key),
              position: LatLng(value["lat"], value["long"]),
              infoWindow: InfoWindow(
                title: value["firsname"],
                snippet: value["email"]
              ),
            ),
          );
        });
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    print("Hello $latitude");
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.157457, 71.524918),
          zoom: 14.0,
        ),
        markers: Set<Marker>.of(markers),
      ),
    );
  }
}
