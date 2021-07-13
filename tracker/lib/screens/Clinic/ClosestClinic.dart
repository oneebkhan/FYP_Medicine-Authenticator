import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/Pharmacy_Clinics_Info.dart';
import 'package:geolocator/geolocator.dart';

class ClosestClinic extends StatefulWidget {
  //ClosestClinic({});

  @override
  _ClosestClinicState createState() => _ClosestClinicState();
}

class _ClosestClinicState extends State<ClosestClinic> {
  double width;
  double height;
  bool con;
  double opac;
  var clinicStream;
  LocationPermission permission;
  var location;
  List clinicsNearYou = [];

  getClinics() async {
    FirebaseFirestore.instance.collection('Clinic').snapshots().listen((event) {
      event.docs.forEach((element) {
        double distance = calculateDistance(
            element.data()['latLong'].latitude,
            element.data()['latLong'].longitude,
            location.latitude,
            location.longitude);
        if (distance <= 1000000000) {
          setState(() {
            clinicsNearYou.add({
              "distance": distance.toInt(),
              "document": element.data(),
            });
          });
        }
      });
    });
  }

  //
  //
  //distance bweteen two geopoints
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double radEarth = 6.3781 * (pow(10.0, 6.0));
    double phi1 = lat1 * (pi / 180);
    double phi2 = lat2 * (pi / 180);

    double delta1 = (lat2 - lat1) * (pi / 180);
    double delta2 = (lng2 - lng1) * (pi / 180);

    double cal1 = sin(delta1 / 2) * sin(delta1 / 2) +
        (cos(phi1) * cos(phi2) * sin(delta2 / 2) * sin(delta2 / 2));

    double cal2 = 2 * atan2((sqrt(cal1)), (sqrt(1 - cal1)));
    double distance = radEarth * cal2;

    return (distance);
  }

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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await Geolocator.getCurrentPosition().then((value) {
      setState(() {
        location = value;
      });
    }).then((value) => getClinics());
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    checkInternet();
    determinePosition();

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
                Text(
                  'Clinics within 10km',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 14,
                  ),
                ),
                SizedBox(
                  height: 20,
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
                                  Navigator.pop(context);
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
                            child: clinicsNearYou.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50, bottom: 50),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: clinicsNearYou.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item = clinicsNearYou[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RowInfo(
                                            imageURL: item["document"]
                                                ['imageURL'][0],
                                            location: item["document"]
                                                ['location'],
                                            width: width,
                                            title: item["document"]['name'],
                                            func: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      Pharmacy_Clinics_Info(
                                                    name: item["document"]
                                                        ['uid'],
                                                    pharmOrClinic: 'Clinic',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Text(
                                              item["distance"].toString() +
                                                  ' kms away from you',
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Divider(
                                            indent: 5,
                                            endIndent: 5,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
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
