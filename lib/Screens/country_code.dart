import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';

class Country_Code extends StatefulWidget {
  const Country_Code({Key? key}) : super(key: key);

  @override
  State<Country_Code> createState() => _Country_CodeState();
}

class _Country_CodeState extends State<Country_Code> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Padding(padding: EdgeInsets.all(16.0)),
            CountryCodePicker(
              initialSelection: "+92",
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              showFlagMain: true,
              favorite: ["+91", "Pak"],
              enabled: true,
              showFlag: true,
            ),      
          ],
        ),
      ),
    );
  }
}


// Center(
//         child: CountryCodePicker(
//           initialSelection: "IN",
//           showCountryOnly: false,
//           showOnlyCountryWhenClosed: false,
//           showFlagMain: true,
//           favorite: ["+92","Pak"],
//           enabled: true,
//           showFlag: true,
//         ),
//       ),