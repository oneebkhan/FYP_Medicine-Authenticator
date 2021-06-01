import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/InfoContainer.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'dart:math' as math;

import 'package:tracker_admin/screens/Pharmacy_Clinics_Info.dart';
import 'package:tracker_admin/screens/admin_screens/Clinic/ViewClinic.dart';

class Clinics extends StatefulWidget {
  @override
  _ClinicsState createState() => _ClinicsState();
}

class _ClinicsState extends State<Clinics> {
  double width;
  double height;
  double opac;
  double opac2;
  // Variable that stores the distributors
  var distributorStream;
  var clinicStream;
  // variable to store urls in the
  List<String> imageURL;
  // connectivity of the application
  bool con;
  List<bool> selection;
  int selectedIndex;

  //
  //
  //Check internet connection
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Not Connected to the Internet!');
      setState(() {
        con = true;
      });
    } else
      setState(() {
        con = false;
      });
  }

  //
  //
  //
  convertToStringList(elements) {
    for (int i; i < elements.length; i++) {
      setState(() {
        imageURL.add(elements[i].toString());
      });
    }
  }

  getClinics() async {
    try {
      setState(() {
        clinicStream = FirebaseFirestore.instance
            .collection('Clinic')
            .orderBy('name')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //
  //
  // The function to get distributors
  getDistributors() async {
    try {
      setState(() {
        distributorStream = FirebaseFirestore.instance
            .collection('Distributor')
            .where('clinicsAdded', isNotEqualTo: []).snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    selection = [false, true];
    opac = 0;
    opac2 = 0;
    imageURL = [];
    selectedIndex = 1;
    getClinics();
    getDistributors();
    checkInternet();

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

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width / 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 14,
                      ),
                    ),
                    SizedBox(
                      width: width / 3.8,
                    ),
                    Text(
                      'View:',
                      style: TextStyle(
                        fontSize: width / 30,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ToggleButtons(
                        fillColor: Colors.white,
                        highlightColor: Color.fromARGB(255, 170, 200, 240),
                        splashColor: Color.fromARGB(255, 170, 200, 240),
                        borderRadius: BorderRadius.circular(10),
                        focusColor: Colors.white,
                        selectedColor: Color.fromARGB(255, 170, 200, 240),
                        onPressed: (int index) {
                          if (index == 0) {
                            setState(() {
                              selection[0] = true;
                              selection[1] = false;
                              //change to all clinics
                              selectedIndex = 0;
                              opac2 = 1;
                              opac = 0;
                            });
                            Fluttertoast.showToast(
                                msg: 'Grouped by Distributors');
                          } else if (index == 1) {
                            setState(() {
                              selection[1] = true;
                              selection[0] = false;
                              //change to distributor clinics
                              selectedIndex = 1;

                              opac2 = 0;
                              opac = 1;
                            });
                            Fluttertoast.showToast(msg: 'All Clinics');
                          }
                        },
                        constraints: BoxConstraints(
                          minHeight: width / 11,
                          minWidth: width / 10,
                        ),
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,
                            size: width / 20,
                          ),
                          Icon(
                            Icons.sort_by_alpha_outlined,
                            size: width / 20,
                          ),
                        ],
                        isSelected: selection,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                //
                //
                // The container fields
                IndexedStack(
                  index: selectedIndex,
                  children: [
                    AnimatedOpacity(
                      opacity: opac2,
                      duration: Duration(milliseconds: 500),
                      child: con == true
                          ? Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 3, bottom: 20),
                                    child: Text('No Internet Connection...'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      checkInternet();
                                    },
                                    child: Text('Reload'),
                                  ),
                                ],
                              ),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: distributorStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData == false) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    QueryDocumentSnapshot item =
                                        snapshot.data.docs[index];
                                    return InfoContainer(
                                      //
                                      //
                                      // function to make the colors change in each container
                                      color: Color((math.Random().nextDouble() *
                                                  0xFFFFFF)
                                              .toInt())
                                          .withOpacity(1.0),
                                      description:
                                          '${item['clinicsAdded'].length} Clinics',
                                      func: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ViewClinic(
                                              pageName: item['name'],
                                              clinics: item['clinicsAdded'],
                                            ),
                                          ),
                                        );
                                      },

                                      title: item['name'],
                                      width: width,
                                      height: height,
                                      countOfImages:
                                          item['clinicsAdded'].length,
                                    );
                                  },
                                );
                              }),
                    ),
                    AnimatedOpacity(
                      opacity: opac,
                      duration: Duration(milliseconds: 500),
                      child: con == true
                          ? Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: height / 3, bottom: 20),
                                    child: Text('No Internet Connection...'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      checkInternet();
                                    },
                                    child: Text('Reload'),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                ),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: clinicStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData == false) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          QueryDocumentSnapshot item =
                                              snapshot.data.docs[index];
                                          return new RowInfo(
                                            imageURL: item['imageURL'][0],
                                            location: item['location'],
                                            width: width,
                                            title: item['name'],
                                            func: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      Pharmacy_Clinics_Info(
                                                    name: item['uid'],
                                                    pharmOrClinic: 'Clinic',
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
