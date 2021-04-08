import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/screens/Dashboard.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
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
  List<DisplayMode> modes = <DisplayMode>[];
  DisplayMode selected;

  @override
  void initState() {
    super.initState();
    opac = 0;
    fetchModes();

    Future.delayed(Duration(milliseconds: 250), () {
      setState(() {
        opac = 1.0;
      });
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(),
        ),
      );
    });
  }

  //
  //
  // set the application to use 60+hz if supported
  Future<void> fetchModes() async {
    try {
      modes = await FlutterDisplayMode.supported;
      modes.forEach(print);
      await FlutterDisplayMode.setMode(modes[0]);

      /// On OnePlus 7T:
      /// #1 1080x2340 @ 90Hz
      /// #2 1080x2340 @ 60Hz
    } on PlatformException catch (e) {
      print(e);
    }
    selected =
        modes.firstWhere((DisplayMode m) => m.selected, orElse: () => null);
    if (mounted) {
      setState(() {});
    }
  }

  Future<DisplayMode> getCurrentMode() async {
    return await FlutterDisplayMode.current;
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
