import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class Uploadimage extends StatefulWidget {
  const Uploadimage({Key? key}) : super(key: key);

  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage> {
  bool loading = false;
  File? _image;
  final picker= ImagePicker();
  firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef= FirebaseDatabase.instance.ref('User');
  Future getImageGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality:80);
    setState(() {
      if(pickedFile !=null){
        _image = File(pickedFile.path);
      }else{
        print('no image picked');
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UploadIMage"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: (){
                getImageGallery();
              } ,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  )
                ),
                child: _image !=null? Image.file(_image!.absolute):
                Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          SizedBox(height: 40,),
          ElevatedButton(
             onPressed: ()async{
            setState(() {
              loading = true;
            });
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername'+DateTime.now().millisecondsSinceEpoch.toString());
            firebase_storage.UploadTask uploadTask= ref.putFile(_image!.absolute);

             Future.value(uploadTask).then((value) async{
              var newurl = await ref.getDownloadURL();

              databaseRef.child('1').set({
                'id': '1212',
                'title': newurl.toString()
              });
            }).onError((error, stackTrace){
            });

          },
              child: Text("Upload Image"),

          ),
        ],
      ),
    );
  }
}
