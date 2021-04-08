import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class RequestMedicine extends StatefulWidget {
  @override
  _RequestMedicineState createState() => _RequestMedicineState();
}

class _RequestMedicineState extends State<RequestMedicine> {
  double width;
  double height;
  double safePadding;
  bool _isLoading = false;
  int docNum = 1;
  TextEditingController nameOfMedicine = TextEditingController();
  TextEditingController barcode = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController nameOfUser = TextEditingController();
  TextEditingController emailOfUser = TextEditingController();
  TextEditingController cellNumberOfUser = TextEditingController();
  TextEditingController locationOfUser = TextEditingController();

  //
  //
  //Check internet connection
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Not Connected to the Internet!');
      return connectivityResult;
    } else
      return null;
  }

  //
  //
  // Get length of documents to make a unique ID for the firestore doca
  // ignore: missing_return
  Future<double> _getLengthOfRequestsMedicine() async {
    await FirebaseFirestore.instance
        .collection("RequestsMedicine")
        .snapshots()
        .listen((doc) {
      doc.docs.forEach((element) {
        if (doc.docs.length == 0) {
          setState(() {
            docNum = 1;
          });
        }
        if (docNum <= element['number']) {
          setState(() {
            docNum = element['number'] + 1;
          });
        }
      });
    });
  }

  //
  //
  // pressing the submit button will submit all the fields and update firestore
  Future<void> _onPressed() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore
          .collection("RequestsMedicine")
          .doc('#' + docNum.toString() + ' (${emailOfUser.text})')
          .set({
        "nameOfMedicine": nameOfMedicine.text,
        "barcode": barcode.text,
        "companyName": companyName.text,
        "nameOfUser": nameOfUser.text,
        "emailOfUser": emailOfUser.text,
        "cellNoOfUser": cellNumberOfUser.text,
        "locationOfUser": locationOfUser.text,
        "number": docNum,
      }).then((_) {
        print("success!");
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

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

  @override
  void initState() {
    super.initState();
    checkInternet();
    _getLengthOfRequestsMedicine();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 246, 246, 248),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.grey[700],
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request Medicine',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ContainerText(
                                hint: 'Name of Medicine',
                                node: node,
                                controller: nameOfMedicine,
                                maxLines: 1,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Barcode',
                                node: node,
                                controller: barcode,
                                maxLength: 30,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Company Name',
                                node: node,
                                controller: companyName,
                                maxLines: 1,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'User Name',
                                node: node,
                                controller: nameOfUser,
                                maxLength: 20,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'User Email',
                                node: node,
                                controller: emailOfUser,
                                maxLength: 30,
                                maxLines: 1,
                                inputType: TextInputType.emailAddress,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'User Cell Phone Number',
                                node: node,
                                controller: cellNumberOfUser,
                                maxLength: 15,
                                maxLines: 1,
                                inputType: TextInputType.phone,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Location of User',
                                node: node,
                                controller: locationOfUser,
                                maxLength: 50,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        if (validateEmail(emailOfUser.text) == null &&
                            checkInternet() == null) {
                          _onPressed();
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(Duration(milliseconds: 2000), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        width: width / 1.1,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 149, 192, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerText extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final node;
  final double height;
  final int maxLength;
  final int maxLines;
  final double width;
  final TextInputType inputType;

  const ContainerText({
    Key key,
    this.controller,
    this.hint,
    this.node,
    this.height,
    this.maxLength,
    this.width,
    this.inputType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      height: height,
      width: width,
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
