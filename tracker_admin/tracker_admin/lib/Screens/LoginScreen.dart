import 'package:flutter/material.dart';
import 'package:tracker_admin/screens/AddDistributor.dart';
import 'package:tracker_admin/screens/Dashboard_Admin.dart';
import 'package:tracker_admin/screens/Dashboard_Distributor.dart';
import 'package:tracker_admin/screens/Dashboard_Pharmacist.dart';

class LoginScreen extends StatefulWidget {
  final int i;

  LoginScreen({Key key, @required this.i}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var width;
  var height;
  double opac;
  double opac2;
  bool anim;
  Color backColor;
  Color floatingButtonColor;
  var email = TextEditingController();
  var pass = TextEditingController();

  @override
  void initState() {
    super.initState();
    opac = 0;

    if (widget.i == 1) {
      backColor = Color.fromARGB(255, 168, 225, 166);
      floatingButtonColor = Color.fromARGB(255, 110, 200, 110);
    } else if (widget.i == 0) {
      backColor = Color.fromARGB(255, 170, 200, 240);
      floatingButtonColor = Color.fromARGB(255, 130, 150, 250);
    } else if (widget.i == 2) {
      backColor = Color.fromARGB(255, 255, 99, 99);
      floatingButtonColor = Color.fromARGB(255, 242, 93, 93);
    }

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.grey[700],
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: backColor),
            ),
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/images/back.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width / 15,
                      vertical: height / 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: height / 15,
                          ),
                        ),
                        SizedBox(
                          height: height / 15,
                        ),
                        ContainerText(
                          hint: 'Email',
                          node: node,
                          controller: email,
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        ContainerText(
                          hint: 'Password',
                          node: node,
                          controller: pass,
                        ),
                        SizedBox(
                          height: height / 20,
                        ),
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              if (widget.i == 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Dashboard_Distributor(),
                                  ),
                                );
                              } else if (widget.i == 0) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Dashboard_Admin(),
                                  ),
                                );
                              } else if (widget.i == 2) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Dashboard_Pharmacist(),
                                  ),
                                );
                              }
                            },
                            padding: EdgeInsets.all(0),
                            child: Container(
                              width: width,
                              height: height / 15,
                              decoration: BoxDecoration(
                                color: floatingButtonColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: height / 45,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
