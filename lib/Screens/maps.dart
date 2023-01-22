import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/Screens/User_Model.dart';
import 'package:maps/main.dart';

// void main() {
//   runApp(MyApp());
// }
class maps extends StatefulWidget {
  const maps({Key? key}) : super(key: key);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  final dbRef = FirebaseDatabase.instance.ref("User");

  @override
  // Widget listItem({required Map User}) {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     padding: const EdgeInsets.all(10),
  //     height: 110,
  //     color: Colors.yellowAccent,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           User["email"],
  //           ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           User["firstname"],
  //           ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           User ["lastname"],
  //           ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           User["gender"],
  //           ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Text(
  //           User["location"],
  //           ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: () {
  //               },
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.edit,
  //                     color: Theme.of(context).primaryColor,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 6,
  //             ),
  //             GestureDetector(
  //               onTap: () {},
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     Icons.delete,
  //                     color: Colors.red,
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: dbRef,
                itemBuilder: (context, snapshot, animation, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    height: 100,
                    color: Color(0xffA87B5D),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.child("email").value.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              snapshot.child("firsname").value.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                            Text(
                              snapshot.child("lastname").value.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                        Text(
                          snapshot.child("gender").value.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          snapshot.child("location").value.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                  // ListTile(
                  //   title: Text(snapshot.child("email").value.toString()),
                  //   subtitle: Text(snapshot.child("location").value.toString()),
                  // );
                  // Map User = snapshot.value as Map;
                  // User['key']= snapshot.key;
                  // return listItem( User:User);
                }),
          ),
        ],
      ),
    );
  }
}
