// postDetailsToFirestore() async {
//   // calling our firestore
//   // calling our user model
//   // sedning these values
//
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   User? user = _auth.currentUser;
//   UserModel userModel = UserModel();
//   // writing all the values
//   userModel.email = user!.email;
//   userModel.uid = user.uid;
//   userModel.firstname = name.text;
//   userModel.lastname = lastname.text;
//
//   await firebaseFirestore
//       .collection("users")
//       .doc(user.uid)
//       .set(userModel.toMap());
//   Fluttertoast.showToast(msg: "Account created successfully :) ");
//
//   Navigator.pushAndRemoveUntil((context),
//       MaterialPageRoute(builder: (context) => Login()), (route) => false);
// }
// StreamBuilder code
// StreamView(Stream.fromFuture(hello())),
// if (!snapshot.hasData || snapshot.data == null) {
//   return const CircularProgressIndicator();
// }
// Map<String,dynamic> userData = snapshot.data!.snapshot.value;
// List<Marker> newMarkers = [];
// userData.forEach((key, value) {
//   double latitude = value["lat"];
//   double longitude = value["long"];
//   String userName = value["firsname"];
//   Marker newMarker = Marker(
//     markerId: MarkerId(key),
//     position: LatLng(latitude, longitude),
//     infoWindow: InfoWindow(title: userName ),
//   );
//   newMarkers.add(newMarker);
// });


// Navigation code from Splash Screen
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

// Password validation code fRom Login Scrreen

// MinLengthValidator(8,
//     errorText: 'password must be at least 8 digits long'),
// PatternValidator(r'(?=.*?[#?!@$%^&*-])',
//     errorText:
//         'passwords must have at least one special character')
