import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps/Screens/Login.dart';
import 'package:maps/Screens/User_Model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

void main() {
  runApp(MyApp());
}

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
  late final TextEditingController picture =

  TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool loading = false;
  firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef= FirebaseDatabase.instance.ref('User');
  @override
  Future getImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text("Select Image", style:TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
          content: const Text("Choose the source of the image",style:TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
          actions: <Widget>[
            TextButton(
              child: const Text("Camera",
                style:TextStyle(
                    color: Color(0xffA87B5D),
                    fontWeight: FontWeight.bold ),),
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
              child: const Text("Gallery",
                style:TextStyle(
                    color: Color(0xffA87B5D),
                    fontWeight: FontWeight.bold ),),
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
  bool isEmail = false;
  int? _value = 1;
  String? errorMessage;

  @override
  void dispose() {
    picture.dispose();
    email.dispose();
    password.dispose();
    name.dispose();
    lastname.dispose();
    Confirmpassword.dispose();
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
              TextFormField(
                onSaved: (value) {
                  name.text = value!;
                },
                controller: name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  label: Text('First Name'),
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
                      errorText: "Name must be at least of 3 chars"),
                ]),
              ),
              const SizedBox(height:20),
              TextFormField(
                controller: lastname,
                onSaved: (value) {
                  lastname.text = value!;
                },
                decoration: InputDecoration(

                  prefixIcon:  Icon(Icons.person),
                  hintText: 'Enter your name',
                  label: Text('Last Name'),
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
                      errorText: "Name must be at least of 3 chars"),
                ]),
              ),
              SizedBox(height: 20),
              type == 'email'
                  ? TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Enter your  Email',
                        label: Text('Email'),
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
              SizedBox(
                height: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(_image!),
                      fit: BoxFit.cover,
                      )
                    ),
                  ) : Container(),
                  // SizedBox(height: 20,),
                  TextFormField(
                    controller: picture,
                    decoration: InputDecoration(
                      labelText: "Please Insert Image Here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: getImage,
                        child: Icon(Icons.camera_alt),
                      )
                    ),
                  )
                ]
              ),
              SizedBox(
                height: 15,
              ),
              // TextFormField(
              //   controller: _textEditingController,
              //   decoration: InputDecoration(
              //     labelText: "Please Insert Image Here",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(50),
              //       borderSide:  BorderSide(
              //         color: Color(0xffA87B5D),
              //       )
              //     ),
              //     prefixIcon:  GestureDetector(
              //       onTap: getImage,
              //       child: Icon(Icons.camera_alt),
              //     ),
              //   ),
              //   validator: (value){
              //     if (_image !=null){
              //       return 'Preview of selected image:';
              //     }
              //     return null;
              //   },
              //   initialValue: _image != null ? _image!.path : null,
              // ),

              SizedBox(height: 5),
              TextFormField(
                onSaved: (value) {
                  password.text = value!;
                },
                controller: password,
                obscureText: !isVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                    icon: isVisible ? Icon(Icons.visibility, color: Colors.black,) :
                    Icon(Icons.visibility_off, color: Colors.grey,),
                  ),
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Enter password',
                  label: Text('Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: (value){
                  value ??= '';
                  if (value.isEmpty)
                    {
                      return 'Please Enter Password';
                    }
                  if (value.length<8) {
                        return 'Password must be 8 Character long';
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)){
                        return 'Password must contain at least one Special Character';
                      }
                  return null;
                },
                // validator:  (value){
                //   value ??= '';
                //   if (value.isEmpty){
                //     return 'Please Enter a Password';
                //   }
                //   if (value.length<8) {
                //     return 'Passwprd must be 8 Character long';
                //   }
                //   if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)){
                //     return 'Password must contain at least one Special Character';
                //   }
                //   return null;
                // },
                // validator: MultiValidator([
                //   RequiredValidator(errorText: 'password is required'),
                //   MinLengthValidator(8,
                //       errorText: 'password must be least 8 digits long'),
                //   PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                //       errorText:
                //           'passwords must have at least one special character'),
                // ]),
              ),
              SizedBox(height: 30),
              TextFormField(
                // onSaved: (value) {
                //   Confirmpassword.text = value!;
                // },
                controller: Confirmpassword,
                obscureText: !isVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                    icon: isVisible ? Icon(Icons.visibility, color: Colors.black,) :
                    Icon(Icons.visibility_off, color: Colors.grey,),
                  ),
                  prefixIcon: Icon(Icons.vpn_key_off),
                  hintText: 'Enter password',
                  label: Text('Confirm Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: const BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: (value){
                  value ??= '';
                  if (value.isEmpty)
                    {
                      return 'Please Re-Enter Password';
                    }
                  if (value.length<8) {
                        return 'Passwprd must be 8 Character long';
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)){
                        return 'Password must contain at least one Special Character';
                      }
                  print(password.text);
                  print(Confirmpassword.text);
                  if (password.text!= Confirmpassword.text){
                    return 'Password and Confirm Password Does not Match';
                  }
                  return null;
                },
                // validator:  (value){
                //   value ??='';
                //   if (value.isEmpty){
                //     return 'Please Enter a Password';
                //   }
                //   if (value.length<8) {
                //     return 'Passwprd must be 8 Character long';
                //   }
                //   if (!RegExp(r'[!@#$%^&*(),.?:|<>]').hasMatch(value)){
                //     return 'Password must contain at least one Special Character';
                //   }
                //   if (value!= _password){
                //     return 'Password do not match';
                //   }
                //   return null;
                // },


                // validator: MultiValidator([
                //   RequiredValidator(errorText: 'password is required'),
                //   MinLengthValidator(8,
                //       errorText: 'password must be least 8 digits long'),
                //   PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                //       errorText:
                //           'passwords must have at least one special character'),
                //
                // ]),
              ),
              SizedBox(height: 20),
              const  Text(
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
                  SizedBox(width: 5),
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
                  SizedBox(width: 5),
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
                  SizedBox(width: 5),
                 const Text(
                    "Others",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffA87B5D)),
                  ),
                  child: _loading
                      ? CircularProgressIndicator()
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),

                  onPressed: () {
                    _formKey.currentState!.validate();
                    {
                      setState(() {
                        loading = true;
                      });
                      String newurl = '';
                      firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref('/images/'+DateTime.now().millisecondsSinceEpoch.toString());
                      firebase_storage.UploadTask uploadTask= ref.putFile(_image!.absolute);

                      Future.value(uploadTask).then((value) async{
                        var newurl = await ref.getDownloadURL();
                        signUp(email.text, password.text, newurl);
                        // postdetailsrealtimedatabase(newurl);
                        // databaseRef.child('1').set({
                        //   /*'id': '1212',
                        //   'title': newurl.toString()*/
                        // });
                      }).onError((error, stackTrace){
                      });

                    };
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, String newUrl) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  postdetailsrealtimedatabase(newUrl)
                })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postdetailsrealtimedatabase(String newurl) async {
    print("callfunction");
    final referDatabasse = FirebaseDatabase.instance.ref("User");
    User? user = _auth.currentUser;
    referDatabasse.child(user!.uid).set({
      "id": user.uid.toString(),
      "email": email.text,
      "picture": newurl.toString(),
      'number': '8856061841',
      "firsname": name.text,
      "lastname": lastname.text,
      "password": password.text,
      "confirmpassword": Confirmpassword.text,
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
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffA87B5D),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });


    postDetailsToFirestore() async {
      // calling our firestore
      // calling our user model
      // sedning these values

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      // writing all the values
      userModel.email = user!.email;
      userModel.uid = user.uid;
      userModel.firstname = name.text;
      userModel.lastname = lastname.text;

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
      Fluttertoast.showToast(msg: "Account created successfully :) ");

      Navigator.pushAndRemoveUntil((context),
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
  }
}
