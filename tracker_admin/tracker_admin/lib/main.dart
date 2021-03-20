import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_admin/screens/StartingPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      title: 'Medicine Tracker - Admin',
    ),
  );
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var width;
  var height;
  double opac;
  bool anim;

  @override
  void initState() {
    super.initState();
    opac = 0;
    anim = false;

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        opac = 1.0;
        anim = true;
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StartingPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 252, 255),
      body: Center(
          child: Container(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 9,
            ),
            SizedBox(
              height: height / 3.5,
              child: Lottie.asset(
                'assets/lottie/medicine.json',
              ),
            ),
            SizedBox(
              height: height / 9,
              child: Lottie.asset(
                'assets/lottie/admin.json',
                animate: anim,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            AnimatedOpacity(
              opacity: opac,
              duration: Duration(milliseconds: 500),
              child: Column(
                children: [
                  Text(
                    'Medicine',
                    style: TextStyle(
                      fontSize: height / 30,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Tracking',
                    style: TextStyle(
                      fontSize: height / 30,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(
                    height: height / 3.3,
                  ),
                  Text(
                    'Made By',
                    style: TextStyle(
                      fontSize: height / 50,
                    ),
                  ),
                  Text(
                    'FA17-BSE-C-021/57/39',
                    style: TextStyle(
                      fontSize: height / 55,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
