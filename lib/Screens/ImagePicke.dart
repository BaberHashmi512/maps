import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'homepage.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key}) : super(key: key);

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  MediaType _mediaType = MediaType.image;

  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip3D(
                      style: ChoiceChip3DStyle.blue,
                      selected: _mediaType == MediaType.image,
                      onSelected: () {
                        setState(() {
                          _mediaType = MediaType.image;
                        });
                      },
                      onUnSelected: () {},
                      height: 50,
                      child: const Text(
                        "Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    ChoiceChip3D(
                      style: ChoiceChip3DStyle.red,
                      selected: _mediaType == MediaType.video,
                      onSelected: () {
                        setState(() {
                          _mediaType = MediaType.video;
                        });
                      },
                      onUnSelected: () {},
                      height: 50,
                      child: const Text(
                        "Video",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                (imagePath != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(imagePath!),
                          height: 200,
                          width: 150,
                          fit: BoxFit.cover,
                        ))
                    : Container(
                        width: 55,
                        height: 55,
                        color: Colors.grey[300]!,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Color.fromARGB(255, 121, 52, 52),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            pickMedia(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            pickMedia(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )));
  }

  void pickMedia(ImageSource source) async {
    XFile? file;
    if (_mediaType == MediaType.image) {
      file = await ImagePicker().pickImage(source: source);
    } else {
      file = await ImagePicker().pickVideo(source: source);
    }
    if (file != null) {
      imagePath = file.path;
      if (_mediaType == MediaType.video) {
        imagePath = await VideoThumbnail.thumbnailFile(
            video: file.path,
            imageFormat: ImageFormat.PNG,
            quality: 100,
            maxWidth: 300,
            maxHeight: 300);
        setState(() {});
      }
    }
  }
}
