import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:maps/Screens/signup.dart';

class Country_Code extends StatefulWidget {
  const Country_Code({Key? key}) : super(key: key);

  @override
  State<Country_Code> createState() => _Country_CodeState();
}

class _Country_CodeState extends State<Country_Code> {

// enum genderPerson { male, female, other }
  genderPerson _value = genderPerson.male;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            IntlPhoneField(
              
    decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Color(0xffA87B5D),
            ),
        ),
    ),
    initialCountryCode: 'PK',
    onChanged: (phone) {
        print(phone.completeNumber);
    },
),
        Container(
                width: double.infinity,
                height: 50.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Radio(
                      value: _value,
                      groupValue: genderPerson.male,
                       onChanged: (genderPerson? value){
                        setState(() {
                          _value = value!;
                        });
                       }),
                       SizedBox(
                        width: 10,
                       ),
                       Text("Male"),
                       Radio(
                      value: _value,
                      groupValue: genderPerson.female,
                       onChanged: (genderPerson? value){
                        setState(() {
                          _value = value!;
                        });
                       }),
                       SizedBox(
                        width: 10,
                       ),
                       Text("Female"),
                       Radio(
                      value: _value,
                      groupValue: genderPerson.other,
                       onChanged: (genderPerson? value){
                        setState(() {
                          _value = value!;
                        });
                       }),
                       SizedBox(
                        width: 10,
                       ),
                       Text("Custome"),
                  ],
                ),
              ),
         
          ],
        ),
      ),
    );
  }
}