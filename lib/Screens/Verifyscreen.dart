import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps/Screens/Login.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verifyscreen extends StatefulWidget {
  final String verificationId;

  const Verifyscreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<Verifyscreen> createState() => _VerifyscreenState();
}

class _VerifyscreenState extends State<Verifyscreen> {
  final number = TextEditingController();
  bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xffA87B5D),
        title: const Text("Verify", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80,),
          PinCodeTextField(
              appContext: context,
            controller: number,
              keyboardType: TextInputType.number,
              inputFormatters:[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              length: 6,
              onChanged: (value){
                print(value);
              },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              inactiveColor: Colors.brown,
              activeColor: Colors.deepOrange,
              selectedColor: Colors.brown,
            ),
          ),
          // TextFormField(
          //   controller: number,
          //   keyboardType: TextInputType.number,
          //   inputFormatters:[
          //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //     FilteringTextInputFormatter.digitsOnly
          //   ],
          //   decoration: const InputDecoration(
          //     hintText: "6 Digit Code"
          //   ),
          // ),
          const SizedBox(
            height: 50,
          ),

          SizedBox(
            height: 50,
            width: 150,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    backgroundColor: const Color(0xffA87B5D)),
                onPressed: ()async{
              setState(() {
                _loading=true;
              });
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: number.text.toString(),
              );
              try{
                await _auth.signInWithCredential(credential);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
              }catch(e){
                setState(() {
                  _loading=false;
                });
              }
            },
                child: _loading?

                   Row(
                     children: const [
                       SizedBox(
                         child: CircularProgressIndicator(
                           valueColor: AlwaysStoppedAnimation<Color>(
                               Colors.white),
                           strokeWidth: 1.5,
                         ),
                         height: 30,
                         width: 30,
                       ),
                       Padding(padding: EdgeInsets.only(left: 10)),
                       Text(
                         "Please Wait",
                         style: TextStyle(
                             fontWeight: FontWeight.bold, fontSize: 15),
                       ),
                     ],
                   ) :
                     const Text("Verify", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          )
          ),
        ],
      ),
    );
  }
}
