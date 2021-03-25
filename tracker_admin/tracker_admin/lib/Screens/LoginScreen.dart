import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker_admin/screens/AddDistributor.dart';
import 'package:tracker_admin/screens/Dashboard_Admin.dart';
import 'package:tracker_admin/screens/Dashboard_Distributor.dart';
import 'package:tracker_admin/screens/Dashboard_Pharmacist.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String user;
  String userName;
  bool isLoading;
  var nav;

  //
  //
  // Validate the Email Address
  String validateEmail(String value) {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Email');
      return "enter email";
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      Fluttertoast.showToast(msg: 'Invalid Email Address');
      return "the email address is not valid";
    }
    return null;
  }

  //
  //
  // validates password
  String validatePassword(String password) {
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Password');
      return "Enter Password";
    }
    if (password.length < 5) {
      Fluttertoast.showToast(
          msg: 'Password length should be greater than 5 charecters');
      return "Password length should be greater than 5 charecters";
    }
    return null;
  }

  //
  //
  // functions to get the admins
  getAdmins(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      var stream = await FirebaseFirestore.instance
          .collection('Admin')
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            userName = value.data()['name'].toString();
            user = value.data()['email'].toString().toLowerCase();
          });
          login();
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Admin not present');
        }
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // function to get the distributors
  getDistributors(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      var stream = await FirebaseFirestore.instance
          .collection('Distributor')
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            userName = value.data()['name'].toString();
            user = value.data()['email'].toString().toLowerCase();
          });
          login();
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Distributor not present');
        }
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // function to get the pharmacists
  getPharmacists(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      var stream = await FirebaseFirestore.instance
          .collection('Pharmacist')
          .doc(uid)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            userName = value.data()['name'].toString();
            user = value.data()['email'].toString().toLowerCase();
          });
          login();
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Pharmacist not present');
        }
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // function to login the user if his account present
  login() async {
    try {
      // ignore: unused_local_variable
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text.toLowerCase(), password: pass.text);
      Fluttertoast.showToast(msg: 'Welcome $userName!');
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => nav,
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    isLoading = false;

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

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
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
                            inputType: TextInputType.emailAddress,
                            maxLines: 1,
                            maxLength: 30,
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          ContainerText(
                            hint: 'Password',
                            node: node,
                            controller: pass,
                            hide: true,
                            maxLength: 30,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: height / 20,
                          ),
                          Center(
                            child: FlatButton(
                              onPressed: () {
                                if (validateEmail(email.text) == null &&
                                    validatePassword(pass.text) == null) {
                                  if (widget.i == 1) {
                                    setState(() {
                                      nav = Dashboard_Distributor();
                                    });
                                    getDistributors(email.text);
                                  } else if (widget.i == 0) {
                                    setState(() {
                                      nav = Dashboard_Admin();
                                    });
                                    getAdmins(email.text);
                                  } else if (widget.i == 2) {
                                    setState(() {
                                      nav = Dashboard_Pharmacist();
                                    });
                                    getPharmacists(email.text);
                                  }
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
      ),
    );
  }
}
