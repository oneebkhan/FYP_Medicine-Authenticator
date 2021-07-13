import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/Pharmacy/ClosestPharmacy.dart';

import 'package:tracker/screens/Pharmacy_Clinics_Info.dart';

class Pharmacies extends StatefulWidget {
  @override
  _PharmaciesState createState() => _PharmaciesState();
}

class _PharmaciesState extends State<Pharmacies> {
  double width;
  double height;
  double opac;
  // Variable that stores the distributors
  var distributorStream;
  var pharmaciesStream;
  // connectivity of the application
  bool con;

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

  getPharmacies() async {
    try {
      setState(() {
        pharmaciesStream = FirebaseFirestore.instance
            .collection('Pharmacy')
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
            .where('pharmacyAdded', isNotEqualTo: []).snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    getPharmacies();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClosestPharmacy(),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 140, 180, 255),
        child: Icon(Icons.location_on),
      ),
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
                Text(
                  'Pharmacies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 14,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //
                //
                // The container fields
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
                                stream: pharmaciesStream,
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
                                                pharmOrClinic: 'Pharmacy',
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
          ),
        ),
      ),
    );
  }
}
