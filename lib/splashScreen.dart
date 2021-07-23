import 'package:flutter/material.dart';
import 'package:image_to_text/home.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 14,
      navigateAfterSeconds: MyHomeScreen(),
      title: Text(
        'Image to text converter',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset(
          'assets/imagetext.png'),
      photoSize: 130,
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
      loadingText: Text("From ESLE"),
    );
  }
}
