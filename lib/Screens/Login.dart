import 'package:flutter/material.dart';
import 'package:maps/Screens/Signup.dart';
import 'package:maps/Screens/Splash.dart';
import 'package:maps/Screens/home.dart';
import 'package:maps/main.dart';
import 'package:maps/utils/color_utils.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    );
  }
} 
  class Login extends StatefulWidget {

  @override
  State<Login> createState() => _HomePageState();
}
class _HomePageState extends State<Login> {
  get inputcontroller => null;
final _formfield = GlobalKey<FormState>();
final emailcontroller = TextEditingController();
final passcontroller = TextEditingController();
bool passToggle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffA87B5D),
        title: Text("Login Page", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 60),
        child: Form(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
            height: 300,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.cover,
                image: AssetImage("assets/images/login5.png"),
                )
            )
              ),
              SizedBox(height: 50),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailcontroller,
                decoration: InputDecoration(
                  labelText: "Email",fillColor: Color(0xffA87B5D),
           border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55), 
             borderSide: BorderSide(color: Color(0xffA87B5D),
             ),
             ),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value){
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                  if (value.isEmpty){
                    return "Enter Email Kindly";
                  }
                  else if(!emailValid){
                    return "Enter Valid Email";
                  }
                  
                },
              ),
              Text("USe Number Instead??", style: TextStyle(fontSize: 10.0,color: Colors.red),),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: passcontroller,
                obscureText: passToggle,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(55), 
             borderSide: BorderSide(color: Color(0xffA87B5D),
             ),),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: Icon(passToggle? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value){
                  if (value!.isEmpty){
                    return "Enter Password";
                  }
                  else if (passcontroller.text.length<6){
                    return "Password length Should be more than 6 Character";
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
            child: Text('Sign In', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>  home()
    ),
  );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffA87B5D)),
                // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 250))
                ),
),

  //              TextButton(
  //               onPressed:() {
  //                   Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) =>  home()
  //   ),
  // );
  //                 },
  //                  child: Text("Sign In", style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20,
  //                   color: Color(0xffA87B5D)
  //                  ),),
  //                  ),
              // InkWell(
              //   onTap: () {
                  
              //   },
              //   child: Container(
              //     height: 50,
              //     decoration: BoxDecoration(
              //       color: Color(0xffA87B5D),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Center(
              //       child: Text("Log IN", style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),),
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account?", style: TextStyle(
                    fontSize: 20,color: Color.fromARGB(255, 2, 1, 1),fontWeight: FontWeight.bold
                  ),
                  ),
                  TextButton(onPressed:() {
                    Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>  Signup()
    ),
  );
                  },
                   child: Text("Sign Up", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xffA87B5D),
                    decoration: TextDecoration.underline,
                   ),),
                   ),
                ],
              ),
            ],

          ), 
        
        ),
        ),
      ),

    );
  }
}