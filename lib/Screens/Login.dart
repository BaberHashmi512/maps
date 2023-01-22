// ignore_for_file: non_constant_identifier_names

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps/Screens/Login.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:maps/Screens/home.dart';
import 'package:maps/Screens/homepage.dart';
import 'package:maps/Screens/location.dart';
import 'package:maps/Screens/signup.dart';
import 'package:maps/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

// const List<String> list = <String>[
//   'Male',
//   'Female',
//   'Custome',
// ];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
//  int? _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Color(0xffA87B5D),
        elevation: 0,
        title: const Text(
          "Login Page",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormSate();
}

class _MyCustomFormSate extends State<MyCustomForm> {
  bool isVisible = true;
  String type = 'email';
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  final email = TextEditingController();
  final password = TextEditingController();
  bool isEmail = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container( 
                  width: 200,
                  height: 200,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image:  new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/login5.png"),
                      ))),
              SizedBox(
                height: 50,
              ),
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
              SizedBox ( 
                height: 5,
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
                              fontFamily: 'RaleWay',
                            ),
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
              // type == 'email'
              //     ? TextButton(
              //         onPressed: () {
              //           setState(() {
              //             type = 'email';
              //           });
              //         },
              //         child: Text("Hello"),
              //       )
              //     : TextButton(
              //         onPressed: () {
              //           setState(() {
              //             type = 'number';
              //           });
              //         },
              //         child: Text("Baber"),
              //       ),
              // Visibility(
              //   visible: isVisible,
              //   child: TextFormField(
              //     controller: email,
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.email),
              //       hintText: 'Enter your  Email',
              //       label: Text('Email'),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(55),
              //         borderSide: BorderSide(
              //           color: Color(0xffA87B5D),
              //         ),
              //       ),
              //     ),
              //     validator: MultiValidator([
              //       RequiredValidator(errorText: "Email required"),
              //       EmailValidator(errorText: "Please insert a valid email")
              //     ]),
              //   ),
              // ),
//               RaisedButton(
//                 child:IntlPhoneField(

//     decoration: InputDecoration(
//         labelText: 'Phone Number',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50),
//             borderSide: BorderSide(
//               color: Color(0xffA87B5D),
//             ),
//         ),
//     ),
//     initialCountryCode: 'PK',
//     onChanged: (phone) {
//         print(phone.completeNumber);
//     },
// ),
//                 onPressed: () {
//                 setState(() {
//                   isVisible= ! isVisible;
//                 });
//               },),
              // SizedBox(height: 08),
              // Row(
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20),
              TextFormField(
                // onSaved: (newValue) {
                //   password.text = newValue!;
                //   _savePassword(newValue);
                // },
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
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
                validator: MultiValidator([
                  RequiredValidator(errorText: 'password is required'),
                  MinLengthValidator(8,
                      errorText: 'password must be least 8 digits long'),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                      errorText:
                          'passwords must have at least one special character')
                ]),
              ),
              SizedBox(height: 50),
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
                          "Log In",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                  onPressed: () async {
                    

                    if (_formKey.currentState!.validate()) {
                      final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            'email', email.text);
                      setState(() {
                        _loading = true;
                      });
                      _auth
                          .signInWithEmailAndPassword(
                              email: email.text.toString(),
                              password: password.text.toString())
                          .then((value) {
                        setState(() {
                          _loading = false;
                        });

                        Navigator.pushAndRemoveUntil(
                            (context),
                            MaterialPageRoute(builder: (context) => homepage()),
                            (route) => false);
                      }).onError((error, stackTrace) {
                        setState(() {
                          _loading = false;
                        });
                      });
                    }
                  },
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    Text(
                      "Already have an Account?",
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 2, 1, 1),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xffA87B5D),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// <COmments For Login>
// import 'package:flutter/material.dart';
// import 'package:maps/Screens/Signup.dart';
// import 'package:maps/Screens/Splash.dart';
// import 'package:maps/Screens/home.dart';
// import 'package:maps/main.dart';
// import 'package:maps/utils/color_utils.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp();
//   }
// }

// class Login extends StatefulWidget {
//   @override
//   State<Login> createState() => _HomePageState();
// }

// class _HomePageState extends State<Login> {
//   get inputcontroller => null;
//   final _formfield = GlobalKey<FormState>();
//   final emailcontroller = TextEditingController();
//   final passcontroller = TextEditingController();
//   bool passToggle = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xffA87B5D),
//         title: Text(
//           "Login Page",
//           style: TextStyle(
//               fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     width: 200,
//                     height: 200,
//                     decoration: new BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: new DecorationImage(
//                           fit: BoxFit.cover,
//                           image: AssetImage("assets/images/login5.png"),
//                         ))),
//                 SizedBox(height: 50),
//                 TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: emailcontroller,
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                     fillColor: Color(0xffA87B5D),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(55),
//                       borderSide: BorderSide(
//                         color: Color(0xffA87B5D),
//                       ),
//                     ),
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   validator: (value) {
//                     bool emailValid = RegExp(
//                             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                         .hasMatch(value!);
//                     if (value.isEmpty) {
//                       return "Enter Email Kindly";
//                     } else if (!emailValid) {
//                       return "Enter Valid Email";
//                     }
//                   },
//                 ),
//                 Text(
//                   "USe Number Instead??",
//                   style: TextStyle(fontSize: 10.0, color: Colors.red),
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: passcontroller,
//                   obscureText: passToggle,
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(55),
//                       borderSide: BorderSide(
//                         color: Color(0xffA87B5D),
//                       ),
//                     ),
//                     prefixIcon: Icon(Icons.lock),
//                     suffixIcon: InkWell(
//                       onTap: () {
//                         setState(() {
//                           passToggle = !passToggle;
//                         });
//                       },
//                       child: Icon(
//                           passToggle ? Icons.visibility : Icons.visibility_off),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return "Enter Password";
//                     } else if (passcontroller.text.length < 6) {
//                       return "Password length Should be more than 6 Character";
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   child: Text(
//                     'Sign In',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => home()),
//                     );
//                   },
//                   style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all(Color(0xffA87B5D)),
//                       // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
//                       textStyle:
//                           MaterialStateProperty.all(TextStyle(fontSize: 250))),
//                 ),

//                 //              TextButton(
//                 //               onPressed:() {
//                 //                   Navigator.of(context).push(
//                 //   MaterialPageRoute(
//                 //     builder: (context) =>  home()
//                 //   ),
//                 // );
//                 //                 },
//                 //                  child: Text("Sign In", style: TextStyle(
//                 //                   fontWeight: FontWeight.bold,
//                 //                   fontSize: 20,
//                 //                   color: Color(0xffA87B5D)
//                 //                  ),),
//                 //                  ),
//                 // InkWell(
//                 //   onTap: () {

//                 //   },
//                 //   child: Container(
//                 //     height: 50,
//                 //     decoration: BoxDecoration(
//                 //       color: Color(0xffA87B5D),
//                 //       borderRadius: BorderRadius.circular(5),
//                 //     ),
//                 //     child: Center(
//                 //       child: Text("Log IN", style: TextStyle(
//                 //         color: Colors.white,
//                 //         fontSize: 20,
//                 //         fontWeight: FontWeight.bold,
//                 //       ),),
//                 //     ),
//                 //   ),
//                 // ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an Account?",
//                       style: TextStyle(
//                           fontSize: 20,
//                           color: Color.fromARGB(255, 2, 1, 1),
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 200,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(builder: (context) => Signup()),
//                         );
//                       },
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                           color: Color(0xffA87B5D),
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
