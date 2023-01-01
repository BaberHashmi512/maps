import 'package:flutter/material.dart';
import 'package:maps/Screens/Login.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _HomePageState();
}

class _HomePageState extends State<Signup> {
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

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormSate();
}

class _MyCustomFormSate extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

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
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  label: Text('First Name'),
                  border: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(55); 
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(5,
                      errorText: "Name must be at least of 5 chars"),
                ]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  label: Text('Middle Name'),
                  border: OutlineInputBorder(),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(3,
                      errorText: "Name must be at least of 3 chars"),
                ]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  label: Text('Last Name'),
                  border: OutlineInputBorder(),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Name required"),
                  MinLengthValidator(5,
                      errorText: "Name must be at least of 5 chars"),
                ]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your  Email',
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Email required"),
                  EmailValidator(errorText: "Please insert a valid email")
                ]),
              ),
              Text("USe Number Instead??", style: TextStyle(fontSize: 10.0,color: Colors.red),),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Phone number',
                  label: Text('Phone'),
                  border: OutlineInputBorder(),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Phone number required"),
                  PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$',
                      errorText: ''),
                ]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter password',
                  label: Text('Password'),
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter password',
                  label: Text('Confirm Password'),
                  border: OutlineInputBorder(),
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
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all (Color(0xffA87B5D)),),
                  child: const Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 20),),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
