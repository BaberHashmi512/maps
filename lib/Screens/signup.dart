import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps/Screens/Login.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

import 'Verifyscreen.dart';

const List<String> list = <String>[
  'Male',
  'Female',
  'Custome',
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final referDatabasse = FirebaseDatabase.instance.ref("User");

//  int? _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black38,
      appBar: AppBar(
          backgroundColor: Color(0xffA87B5D),
          elevation: 0,
          title: const Text('Sign Up Page')),
      body: const MyCustomForm(),
    );
  }
}

enum genderPerson { male, female, other }

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormSate();
}

class _MyCustomFormSate extends State<MyCustomForm> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool isInternetWorking = true;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (isDeviceConnected &&
          isInternetWorking == false &&
          isAlertSet == false) {
        isInternetWorking = await checkInternetWorking();
        if (isInternetWorking == false) {
          showDialogBox();
          setState(() => isAlertSet = true);
        }
      } else if (!isDeviceConnected && isAlertSet == false) {
        showDialogBox();
        setState(() => isAlertSet = true);
      }
    });
  }

  late final TextEditingController picture = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  // bool loading = false;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('User');

  @override
  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Image",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            "Choose the source of the image",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Camera",
                style: TextStyle(
                    color: Color(0xffA87B5D), fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                    picture.text = _image!.path;
                  });
                }
              },
            ),
            TextButton(
              child: const Text(
                "Gallery",
                style: TextStyle(
                    color: Color(0xffA87B5D), fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                    picture.text = _image!.path;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  String type = 'email';
  final name = TextEditingController();
  final lastname = TextEditingController();
  final number = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final Confirmpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _password;
  var _confirmpassword;
  bool _loading = false;
  bool isVisible = false;
  bool ishide= false;
  bool isEmail = false;
  int? _value = 1;
  var errorMessage = "";

  // String? errorMessage;

  @override
  void dispose() {
    picture.dispose();
    email.dispose();
    password.dispose();
    name.dispose();
    lastname.dispose();
    Confirmpassword.dispose();
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 5),
              TextFormField(
                onSaved: (value) {
                  name.text = value!;
                },
                controller: name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter your name',
                  label: const Text('First Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(3,
                      errorText: "Name must be more than 2 Characters"),
                ]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: lastname,
                onSaved: (value) {
                  lastname.text = value!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter your name',
                  label: const Text('Last Name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(3,
                      errorText: "Name must be more than 2 Characters"),
                ]),
              ),
              const SizedBox(height: 20),
              type == 'email'
                  ? TextFormField(
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'Enter your  Email',
                        label: const Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(55),
                          borderSide: const BorderSide(
                            color: Color(0xffA87B5D),
                          ),
                        ),
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Email required"),
                        EmailValidator(errorText: "Please insert a valid email")
                      ]),
                    )
                  : IntlPhoneField(
                      controller: number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Color(0xffA87B5D),
                          ),
                        ),
                      ),
                      initialCountryCode: 'PK',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
              Row(
                children: [
                  isEmail
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              isEmail = false;
                              type = 'email';
                              number.clear();
                            });
                          },
                          child: const Text(
                            "Use Email",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'RaleWay'),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              isEmail = true;
                              type = 'number';
                              email.clear();
                            });
                          },
                          child: const Text(
                            "Use Phone Number Instead?",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'RaleWay',
                            ),
                          ),
                        ),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                _image != null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  readOnly: true,
                  controller: picture,
                  decoration: InputDecoration(
                      labelText: "Please Insert Image Here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: getImage,
                        child: const Icon(Icons.camera_alt),
                      )),
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: 'Image is Necessary PLease Image')
                  ]),
                )
              ]),
              const SizedBox(height: 15),
              TextFormField(
                onSaved: (value) {
                  password.text = value!;
                },
                controller: password,
                obscureText: !isVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: isVisible
                        ? const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                  ),
                  prefixIcon: const Icon(Icons.vpn_key),
                  hintText: 'Enter password',
                  label: const Text('Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: (value) {
                  value ??= '';
                  if (value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  if (value.length < 8) {
                    return 'Password must be 8 Character long';
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)) {
                    return 'Password must contain at least one Special Character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: Confirmpassword,
                obscureText: !ishide,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        ishide = !ishide;
                      });
                    },
                    icon: ishide
                        ? const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                  ),
                  prefixIcon: const Icon(Icons.vpn_key_off),
                  hintText: 'Enter password',
                  label: const Text('Confirm Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: (value) {
                  value ??= '';
                  if (value.isEmpty) {
                    return 'Please Re-Enter Password';
                  }
                  // if (value.length < 8) {
                  //   return 'Passwprd must be 8 Character long';
                  // }
                  // if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)) {
                  //   return 'Password must contain at least one Special Character';
                  // }
                  print(password.text);
                  print(Confirmpassword.text);
                  if (password.text != Confirmpassword.text) {
                    return 'Password Does not Match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Gender",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xffA87B5D),
                    fontSize: 30),
              ),
              Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: _value,
                      onChanged: (Value) {
                        setState(() {
                          _value = Value! as int?;
                        });
                      }),
                  const SizedBox(width: 5),
                  const Text(
                    "Male",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      value: 2,
                      groupValue: _value,
                      onChanged: (Value) {
                        setState(() {
                          _value = Value! as int?;
                        });
                      }),
                  const SizedBox(width: 5),
                  const Text(
                    "Female",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      value: 3,
                      groupValue: _value,
                      onChanged: (Value) {
                        setState(() {
                          _value = Value! as int?;
                        });
                      }),
                  const SizedBox(width: 5),
                  const Text(
                    "Others",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: Color(0xffA87B5D)
                      // MaterialStateProperty.all(Color(0xffA87B5D)),
                      ),
                  child: _loading
                      ? Row(
                          children: const [
                            SizedBox(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 1.5,
                              ),
                              height: 30,
                              width: 30,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Please Wait",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                  onPressed: () async {
                    _auth.verifyPhoneNumber(
                        phoneNumber: "+92"+number.text,
                        verificationCompleted: (_){},
                        verificationFailed: (FirebaseAuthException e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("boohoo"))
                          );
                          // errorMessage.toString();
                        },
                        codeSent: (String verificationId, int? token){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> Verifyscreen(verificationId: verificationId,)));
                        },
                        codeAutoRetrievalTimeout: (e){errorMessage.toString();
                        }
                    );
                    bool isConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (isConnected) {
                      if (_formKey.currentState!.validate()) {
                        // if (number.text.isNotEmpty) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text('Please use email to sign up!')),
                        //   );
                        //   return;
                        // }
                        return setState(() {
                          _loading = true;
                          {
                            String newurl = '';
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref('/images/' +
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString());
                            firebase_storage.UploadTask uploadTask =
                                ref.putFile(_image!.absolute);
                            Future.value(uploadTask).then((value) async {
                              var newurl = await ref.getDownloadURL();
                              signUp(email.text, password.text, newurl);
                              // postdetailsrealtimedatabase(newurl);
                              // databaseRef.child('1').set({
                              //   /*'id': '1212',
                              //   'title': newurl.toString()*/
                              // });
                              debugPrint(errorMessage);
                            }
                            ).onError((error, stackTrace) {});
                            Future.value().then((value) async{
                              var newurl = await ref.getDownloadURL();
                              signUpWithPhoneNumber(number.text, password.text, newurl);
                            });
                          }
                          // Future.delayed(const Duration(seconds: 30), () {
                          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //       content: Text(
                          //           "Storage is full you can't sign up right now!")));
                          //   setState(() {
                          //     _loading = false;
                          //   });
                          // });
                        });
                      }
                    } else {
                      showDialogBox();
                      _loading = false;
                    }

                    // if(email == RegExpMatch){
                    //   return signUp(email.text, password.text, newUrl );
                    // } else{
                    //   return signUpWithPhoneNumber(number.text, password.text, newUrl );
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUp(String email, String password, String newUrl) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postdetailsrealtimedatabase(newUrl)});
      } on FirebaseAuthException catch (error) {
        errorMessage = 'An error has occurred.';
        debugPrint(error.code);
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'Your Email Address Already Exists';
            break;
          case 'quota-exceeded':
            errorMessage = 'Storage is full you can not signup right now';
            break;
        }
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future<void> signUpWithPhoneNumber(String number, String password, String newUrl) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            postdetailsrealtimedatabase(newUrl);
          },
          verificationFailed: (FirebaseAuthException e) {
          },
          codeSent: (String verificationId, int? resendToken) async {
            String smsCode = "123456";
            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
            await _auth.signInWithCredential(credential);
            postdetailsrealtimedatabase(newUrl);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
          },
        );
      } on FirebaseAuthException catch (error) {
        errorMessage = 'An error has occurred.';
        debugPrint(error.code);
        switch (error.code) {
          case 'quota-exceeded':
            errorMessage = 'Storage is full you can not signup right now';
            break;
        }
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }


  // on FirebaseAuthException catch (error) {
  //   errorMessage = 'An error has occurred.';
  //   debugPrint(error.code);
  //   if (error.code == "email-already-in-use") {
  //     errorMessage = "Your Email Address Already Exists";
  //   }
  //   else if (error.code == "quota-exceeded") {
  //     errorMessage = "Storage is full you can't sign up right now!";
  //   }
  //   setState(() {
  //     _loading = false;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(errorMessage)),
  //   );
  // }

  postdetailsrealtimedatabase(String newurl) async {
    print("callfunction");
    final referDatabasse = FirebaseDatabase.instance.ref("User");
    User? user = _auth.currentUser;
    referDatabasse.child(user!.uid).set({
      "id": user.uid.toString(),
      "email": email.text,
      "picture": newurl.toString(),
      'number': number.text,
      "firstname": name.text,
      "lastname": lastname.text,
      "password": password.text,
      "Confirm-password": Confirmpassword.text,
      "gender": "Male",
      "location": "",
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Account Created Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xffA87B5D),
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushAndRemoveUntil((context),
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    });
  }

  checkInternetWorking() async {
    final response = await http.get(Uri.parse('https://www.google.com'));
    return response.statusCode == 200;
  }

  showDialogBox() => showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("No Connection"),
            content: const Text("Please Check your Internet Connection"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  // if(!isDeviceConnected){
                  //   showDialogBox();
                  //   setState(() => isAlertSet = true);
                  // }
                },
                child: const Text("OK"),
              )
            ],
          ));
}
