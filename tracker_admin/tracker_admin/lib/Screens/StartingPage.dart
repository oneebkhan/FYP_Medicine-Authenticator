import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_icons/line_icons.dart';

class StartingPage extends StatefulWidget {
  StartingPage({Key key}) : super(key: key);

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  var width;
  var height;
  double opac;
  double opac2;
  bool anim;
  Color backColor;
  Color floatingButtonColor;
  String lottieAsset;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    anim = false;
    lottieAsset = 'assets/lottie/admin_working.json';
    //lottieAsset = 'assets/lottie/pharmacist.json';
    backColor = Color.fromARGB(255, 170, 200, 240);

    floatingButtonColor = Color.fromARGB(255, 130, 150, 250);
    //backColor = Color.fromARGB(255, 168, 225, 166);
    selectedIndex = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
        opac2 = 1.0;
        anim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              backgroundColor: floatingButtonColor,
              child: Text(
                'Go',
                style: TextStyle(fontSize: height / 40),
              ),
              onPressed: () {},
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Center(
              child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                height: height,
                width: width,
                color: backColor,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: opac2,
                      duration: Duration(milliseconds: 250),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height / 7,
                            ),
                            SizedBox(
                              height: height / 3.5,
                              child: Lottie.asset(
                                lottieAsset,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 2.5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          AnimatedOpacity(
                            opacity: opac,
                            duration: Duration(milliseconds: 250),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height / 12,
                                  width: width / 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Login as..',
                                      style: TextStyle(
                                        fontSize: height / 30,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 3.3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/back.png'),
                  ),
                ),
              ),
            ],
          )),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 120,
            left: width / 5.8,
            right: width / 5.8,
          ),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10,
                ),
                child: GNav(
                  mainAxisAlignment: MainAxisAlignment.center,
                  haptic: true,
                  rippleColor: backColor,
                  hoverColor: backColor,
                  gap: 8,
                  activeColor: floatingButtonColor,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.grey[100],
                  tabs: [
                    GButton(
                      icon: LineIcons.userShield,
                      text: 'Admin',
                    ),
                    GButton(
                      icon: LineIcons.stethoscope,
                      text: 'Distributor',
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      selectedIndex = index;
                      if (index == 1) {
                        setState(() {
                          backColor = Color.fromARGB(255, 168, 225, 166);
                          floatingButtonColor =
                              Color.fromARGB(255, 110, 200, 110);
                          lottieAsset = 'assets/lottie/pharmacist.json';
                        });
                      } else {
                        setState(() {
                          backColor = Color.fromARGB(255, 170, 200, 240);
                          floatingButtonColor =
                              Color.fromARGB(255, 130, 150, 250);
                          lottieAsset = 'assets/lottie/admin_working.json';
                        });
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
