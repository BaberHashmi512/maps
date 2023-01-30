import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = true;
  String type = 'email';
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  Future _authenticateUser(String email, String password) async {}
  // final _auth = FirebaseAuth.instance;
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

  Future<void> login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        final result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        User? user = result.user;
        setState(() {
          _loading = true;
        });
        // Navigator.pushAndRemoveUntil(
        //     (context),
        //     MaterialPageRoute(builder: (context) => homepage()),
        //     (route) => false);
        Get.to(
          () => homepage(),
          transition: Transition.circularReveal,
          duration: Duration(
            milliseconds: 500,
          ),
        );
      } catch (error) {
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(msg: error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
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
              SizedBox(
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
              TextFormField(
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
                      login(email.text, password.text);
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString('email', email.text);
                      //        var user = await _authenticateUser (email.text, password.text);
                      //        if (user == null ){
                      //         setState(() {
                      //             _errorMessage = "Account does not exist";
                      //         });
                      //        } else if (!user.validatePassword(password.text))

                      //         {
                      //         setState(() {
                      //             _errorMessage = "Password is wrong";
                      //         });
                      //     }else {
                      //         // Perform login
                      //         setState(() {
                      //             _errorMessage !=null;
                      //         });
                      //     }_errorMessage != null
                      // ? Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 14),)
                      // : Container();
                      //       final SharedPreferences sharedPreferences =
                      //             await SharedPreferences.getInstance();
                      //         sharedPreferences.setString(
                      //             'email', email.text);
                      //       setState(() {
                      //         _loading = true;
                      //       });
                      //       _auth
                      //           .signInWithEmailAndPassword(
                      //               email: email.text.toString(),
                      //               password: password.text.toString())
                      //           .then((value) {
                      //         setState(() {
                      //           _loading = false;
                      //         });

                      // }).onError((error, stackTrace) {
                      //   setState(() {
                      //     _loading = false;
                      //   });
                      // });
                    }),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: [
                    const Text(
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
                      child: const Text(
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
