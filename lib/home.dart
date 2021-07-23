import 'dart:io';
// import 'dart:js_util';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  String result = "";
  File image;
  ImagePicker imagePicker;

  pickImageFromGallery() async {
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.gallery);
      File imageNew = File(pickedFile.path);
      setState(() {
        image = imageNew;
        labelImage();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  captureImageFromCamera() async {
    try {
      PickedFile pickedFile =
          await imagePicker.getImage(source: ImageSource.camera);
      File imageNew = File(pickedFile.path);
      setState(() {
        image = imageNew;
        labelImage();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  labelImage() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecognizer.processImage(firebaseVisionImage);
    result = "";

    setState(() {
      for (TextBlock textBlock in visionText.blocks) {
        final String text = textBlock.text;

        for (TextLine textLine in textBlock.lines) {
          for (TextElement textElement in textLine.elements) {
            result += textElement.text + " ";
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(width: 100),
            Container(
              height: 280,
              width: 250,
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    result,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/note.jpg'), fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/pin.png',
                          height: 240,
                          width: 240,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: () async {
                        pickImageFromGallery();
                      },
                      onLongPress: () async {
                        captureImageFromCamera();
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: image != null
                            ? Image.file(
                                image,
                                width: 140,
                                height: 192,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 240,
                                height: 200,
                                child: Icon(
                                  Icons.camera_front,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
