// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps/Screens/Login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:maps/Screens/User_Model.dart';
import 'package:maps/main.dart';

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
//  int? _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black38,
      appBar: AppBar(
          backgroundColor: Color(0xffA87B5D),
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
  final name = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final Confirmpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;
  String? errorMessage;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    lastname.dispose();
    Confirmpassword.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  genderPerson _value = genderPerson.male;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
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
                    borderSide: BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),

                  // border: OutlineInputBorder(

                  // ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(3,
                      errorText: "Name must be at least of 3 chars"),
                ]),
              ),
              SizedBox(height: 20),
              // TextFormField(
              //   decoration: InputDecoration(
              //     hintText: 'Enter your name',
              //     label: Text('Middle Name'),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(55),
              //       borderSide: BorderSide(
              //         color: Color(0xffA87B5D),
              //       ),
              //     ),
              //   ),
              //   validator: MultiValidator([
              //     RequiredValidator(errorText: "Name required"),
              //     MinLengthValidator(3,
              //         errorText: "Name must be at least of 3 chars"),
              //   ]),
              // ),
              const SizedBox(height: 20),
              TextFormField(
                controller: lastname,
                onSaved: (value) {
          lastname.text = value!;
        },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  label: Text('Last Name'),
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(
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

              GestureDetector(
                onTap: () {
                  CountryCodePicker(
                    initialSelection: "+92",
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    showFlagMain: true,
                    favorite: ["+92", "Pak"],
                    enabled: true,
                    showFlag: true,
                  );
                },
                child: DropdownButtonExample(),
                // child: Text(
                //   "USe Number Instead??",
                //   style: TextStyle(fontSize: 10.0, color: Colors.red),
                // ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (value) {
          email.text = value!;
        },
                controller: email,
                decoration: InputDecoration(

                  hintText: 'Enter your  Email',
                  prefixIcon: Icon(Icons.email),
                  label: Text('Email'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Email required"),
                  EmailValidator(errorText: "Please insert a valid email")
                ]),
              ),

              // TextFormField(
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(
              //     hintText: 'Phone number',
              //     label: Text('Phone'),
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: MultiValidator([
              //     RequiredValidator(errorText: "Phone number required"),
              //     PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$',
              //         errorText: ''),
              //   ]),
              // ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (value) {
          password.text = value!;
        },
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Enter password',
                  label: Text('Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'password is required'),
                  MinLengthValidator(8,
                      errorText: 'password must be least 8 digits long'),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                      errorText:
                          'passwords must have at least one special character')
                ]),
              ),
              SizedBox(height: 20),
              TextFormField(
                onSaved: (value) {
          Confirmpassword.text = value!;
        },
                controller: Confirmpassword,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Enter password',
                  label: Text('Confirm Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55),
                    borderSide: BorderSide(
                      color: Color(0xffA87B5D),
                    ),
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'password is required'),
                  MinLengthValidator(8,
                      errorText: 'password must be least 8 digits long'),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                      errorText:
                          'passwords must have at least one special character')
                ]),
              ),
              SizedBox(height: 20),
              Text(
                "Gender",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xffA87B5D),
                    fontSize: 30),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio(
                          // value: _value,
                          value: genderPerson.male,
                          groupValue: _value,
                          onChanged: (genderPerson? value) {
                            setState(() {
                              _value = value!;
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Male"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: genderPerson.female,
                          groupValue: _value,
                          onChanged: (genderPerson? value) {
                            setState(() {
                              _value = value!;
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Female"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: genderPerson.other,
                          groupValue: _value,
                          onChanged: (genderPerson? value) {
                            setState(() {
                              _value = value!;
                            });
                          }),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Custom"),
                    ],
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
                      : Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                  onPressed: () {
signUp(email.text, password.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
    void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
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

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false);
  }
}

// class _value {
// }

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Color(0xffA87B5D)),
      underline: Container(
        height: 4,
        color: Color(0xffA87B5D),
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
