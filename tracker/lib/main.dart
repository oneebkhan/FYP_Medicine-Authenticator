import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/screens/Dashboard.dart';

void main() {
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

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        opac = 1.0;
      });
    });

    Future.delayed(Duration(seconds: 4), () {
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
              height: width / 3,
            ),
            SizedBox(
              height: width / 1.5,
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
                        fontSize: width / 17, color: Colors.grey[700]),
                  ),
                  Text(
                    'Tracking',
                    style: TextStyle(
                        fontSize: width / 17, color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: width / 1.8,
                  ),
                  Text(
                    'Made By',
                    style: TextStyle(
                      fontSize: width / 30,
                    ),
                  ),
                  Text(
                    'FA17-BSE-C-021/57/39',
                    style: TextStyle(
                        fontSize: width / 35, color: Colors.grey[700]),
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
