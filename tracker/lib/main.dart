import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/screens/Dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Medicine Tracker',
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var width;
  var height;
  double opac;
  @override
  void initState() {
    super.initState();
    opac = 0;

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opac = 1.0;
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(),
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
              height: height / 6,
            ),
            SizedBox(
              height: height / 3,
              child: Lottie.asset(
                'assets/lottie/medicine.json',
              ),
            ),
            SizedBox(
              height: 10,
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
                    height: height / 3,
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
