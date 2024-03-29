import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps/Screens/marker.dart';
import 'package:maps/Screens/signup.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp();
//   }
// }

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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffA87B5D),
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
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  bool isInternetWorking = true;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isVisible = false;
  String type = 'email';
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";
  var message;
  var errorMessage = "";

  Future _authenticateUser(String email, String password) async {}

  // final _auth = FirebaseAuth.instance;
  bool _loading = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final _codeController = TextEditingController();
  bool isEmail = false;
  bool _isshow = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    subscription.cancel();
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/login5.png"),
                      ))),
              const SizedBox(
                height: 50,
              ),
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
              const SizedBox(
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
                              number.clear();
                              _isshow = !_isshow;
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
                              email.clear();
                              _isshow = !_isshow;
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
              Visibility(
                visible: _isshow,
                child: TextFormField(
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
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Enter password',
                    label: const Text('Password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(55),
                      borderSide: const BorderSide(
                        color: Color(0xffA87B5D),
                      ),
                    ),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'password is required'),
                  ]),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: const Color(0xffA87B5D)),
                    // MaterialStateProperty.all(Color(0xffA87B5D)),
                    child: _loading
                        ? Row(
                            children: const [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 1.5,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                "Please Wait",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ],
                          )
                        : const Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                    onPressed: () async {
                      bool isConnected =
                          await InternetConnectionChecker().hasConnection;
                      if (isConnected) {
                        // if (number.text.isNotEmpty) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text('Please use email to log in!')),
                        //   );
                        //   return;
                        // }
                        _formKey.currentState!.validate();
                        if (email.text.isNotEmpty && number.text.isEmpty) {
                          loginwithemail(email.text, password.text);
                        } else {
                          loginwithphonenumber();
                        }
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString('email', email.text);
                      } else {
                        showDialogBox();
                        _loading = false;
                      }
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
                    const SizedBox(
                      height: 150,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => Signup(),
                            transition: Transition.circularReveal,
                            duration: const Duration(seconds: 1));
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

  checkInternetWorking() async {
    final response = await http.get(Uri.parse('https://www.google.com'));
    return response.statusCode == 200;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
                child: Text("OK"),
              )
            ],
          ));

  loginwithemail(String email, String password) async {
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
        if (user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
        }
      } on FirebaseAuthException catch (error) {
        message = 'An error has occurred.'; // default message
        // debugPrint(error.code);
        switch (error.code) {
          case 'user-not-found':
            message =
                'There is no user account with the email address provided.';
            break;
          case 'wrong-password':
            message = 'Invalid password. Please enter correct password.';
            break;
        }
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        // Fluttertoast.showToast(msg: error.toString());
      }
    }
  }

  loginwithphonenumber() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await _auth.verifyPhoneNumber(
          phoneNumber: "+92" + number.text,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            Navigator.of(context).pop();

            UserCredential result =
                await _auth.signInWithCredential(credential);

            User? user = result.user;

            if (user != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              _signOut();
            } else {
              debugPrint("Error");
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login failed Try again later !")));
            setState(() {
              _loading = false;
            });
            // errorMessage.toString();
          },
          codeSent: (String verificationId, int? token) {
            setState(() {
              _loading = false;
            });
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "Give the code?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        PinCodeTextField(
                          appContext: context,
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          length: 6,
                          onChanged: (value) {
                            print(value);
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 40,
                            fieldWidth: 30,
                            inactiveColor: Colors.brown,
                            activeColor: Colors.deepOrange,
                            selectedColor: Colors.brown,
                          ),
                        ),
                        // TextField(
                        //   controller: _codeController,
                        // ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffA87B5D),
                            foregroundColor: Colors.white),
                        child: _loading
                            ? Row(
                                children: const [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  Text(
                                    "Please Wait",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              )
                            : const Text(
                                "Confirm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          UserCredential userCredential =
                              await _auth.signInWithCredential(credential);

                          User? user = userCredential.user;
                          if (user != null) {
                            try {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Incorrect Code")),
                              );
                              setState(() {
                                _loading = false;
                              });
                            }
                            _signOut();
                          } else {
                            debugPrint("Error");
                          }
                        },
                      )
                    ],
                  );
                });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Verifyscreen(
            //       verificationId: verificationId,
            //     ),
            //   ),
            // );
          },
          codeAutoRetrievalTimeout: (e) {
            errorMessage.toString();
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
}
