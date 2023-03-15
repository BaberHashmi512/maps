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