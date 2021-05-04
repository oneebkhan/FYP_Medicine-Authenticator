import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';

// ignore: must_be_immutable
class EditDistributor extends StatefulWidget {
  @override
  _EditDistributorState createState() => _EditDistributorState();
}

class _EditDistributorState extends State<EditDistributor> {
  double width;
  double height;
  double safePadding;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String currentDistributorEmail;
  bool _isLoading = false;

  //
  //
  // this functions adds a distributor to Firebase Auth
  registerDistributor() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      addDistributorInfo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  //
  //
  // this function adds distributor information to Firebase Firestore
  addDistributorInfo() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("Distributor").doc(email.text).set({
        "name": name.text,
        "email": email.text,
        "companyName": companyName.text,
        "location": location.text,
        "addedByAdmin": currentDistributorEmail,
        "phoneNumber": phoneNumber.text,
        "dateAdded": Timestamp.now(),
        "clinicImages": [],
        "clinicsAdded": [],
        "pharmacyAdded": [],
        "pharmacyImages": [],
        "image": '',
        "salesNumber": 0,
        "sales": {
          "Timestamp": [
            "Timestamp",
            "PharmacistID",
            "the medicine that was sold/authenticated"
          ],
        },
      }).then((_) {
        Fluttertoast.showToast(msg: 'Distributor created Succesfully!');
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // this stores the current distributor email
    currentDistributorEmail = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);
    var medName = TextEditingController();

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
            child: Column(
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
                              'Add Distributor',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width / 16,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ContainerText(
                              hint: 'User Name',
                              node: node,
                              controller: name,
                              maxLength: 20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ContainerText(
                              hint: 'User Email',
                              node: node,
                              controller: email,
                              inputType: TextInputType.emailAddress,
                              maxLength: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ContainerText(
                              hint: 'Password',
                              node: node,
                              controller: password,
                              hide: true,
                              maxLength: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ContainerText(
                              hint: 'Phone Number',
                              node: node,
                              controller: phoneNumber,
                              inputType: TextInputType.phone,
                              maxLength: 15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ContainerText(
                              hint: 'Company Name',
                              node: node,
                              controller: companyName,
                              maxLength: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ContainerText(
                              hint: 'Location',
                              node: node,
                              controller: location,
                              maxLength: 30,
                            ),
                            SizedBox(
                              height: 20,
                            )
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
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      if (name.text.isEmpty ||
                          email.text.isEmpty ||
                          password.text.isEmpty ||
                          phoneNumber.text.isEmpty ||
                          companyName.text.isEmpty ||
                          location.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Fill all the fields!');
                      } else {
                        registerDistributor();
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
    );
  }
}
