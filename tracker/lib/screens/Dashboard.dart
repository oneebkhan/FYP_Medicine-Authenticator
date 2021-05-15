import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tracker/Models/CoronaModel.dart';
import 'package:tracker/Widgets/CarroselWidgets.dart';
import 'package:tracker/screens/About.dart';
import 'package:tracker/screens/Clinic/Clinics.dart';
import 'package:tracker/screens/MedicineInfo.dart';
import 'package:tracker/screens/Pharmacy/Pharmacies.dart';
import 'package:tracker/screens/Search.dart';
import 'package:tracker/screens/Tips.dart';
import 'package:tracker/screens/ViewMedicine.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double width;
  double height;
  double safePadding;
  var medID;
  var medName;
  bool con;
  var subscription;
  int current = 0;
  List<Widget> car = [];
  var jsonCorona;
  String alert;
  String alertStatus;
  String alertDescription;
  String vaccinationAge;

//api variables
  String cases;
  String infected;
  String critical;
  String deceased;
  String recovered;

  //
  //
  // gets the firebase data of that particular medicine
  getAlertsInfo() async {
    try {
      var stream = await FirebaseFirestore.instance
          .collection('Alerts')
          .doc('Corona')
          .get()
          .then((value) {
        setState(() {
          alert = value.data()['name'];
          alertStatus = value.data()['status'];
          alertDescription = value.data()['description'];
          vaccinationAge = value.data()['ageForVaccination'];
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // Get the corona model to get the latest data from API
  Future<CoronaModel> getCases() async {
    final url =
        "https://api.apify.com/v2/key-value-stores/QhfG8Kj6tVYMgud6R/records/LATEST?disableRedirect=true";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return CoronaModel.fromJson(json);
    } else {
      Fluttertoast.showToast(msg: 'Error Loading Corona API');
      throw Exception();
    }
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

  //
  //
  // emties the med ID after the medicine info page is opened
  nullTheMed() {
    setState(() {
      medID = '';
      medName = '';
    });
  }

//
//
// the function to scan the barcode
  Future _scan() async {
    try {
      await Permission.camera.request();
      var barcode = await scanner.scan();
      nullTheMed();
      var result = await FirebaseFirestore.instance
          .collection("Medicine")
          .where("barcode", isEqualTo: barcode)
          .get();
      result.docs.forEach((res) {
        setState(() {
          medID = res.data()['barcode'];
          medName = res.data()['name'];
        });
      });
      if (barcode == null) {
        print('nothing return.');
      } else if (medID == '') {
        Fluttertoast.showToast(msg: 'No Medicine with this barcode');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicineInfo(
              medBarcode: medID,
              medName: medName,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future _scanPhoto() async {
    try {
      await Permission.storage.request();
      var barcode = await scanner.scanPhoto();
      nullTheMed();
      var result = await FirebaseFirestore.instance
          .collection("Medicine")
          .where("barcode", isEqualTo: barcode)
          .get();
      result.docs.forEach((res) {
        setState(() {
          medID = res.data()['barcode'];
          medName = res.data()['name'];
        });
      });
      if (barcode == null) {
        print('nothing return.');
      } else if (medID == '') {
        Fluttertoast.showToast(msg: 'No Medicine with this barcode');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicineInfo(
              medBarcode: medID,
              medName: medName,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAlertsInfo();
    checkInternet();
    medID = '';
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    car = [
      Corona(
        height: height,
        width: width,
        widget: getWidget(),
        title: alert == null ? 'Corona' : alert,
        status: alertStatus == null ? 'High Alert' : alertStatus,
        description: alertDescription == null
            ? 'Lockdown in effect stay in-doors'
            : alertDescription,
      ),
      Vaccination(
        height: height,
        width: width,
        ageVaccination: vaccinationAge,
      ),
      TipsCarosel(
        height: height,
        width: width,
      ),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (width / 15),
                ),
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 15,
                  ),
                ),
                Text(
                  'To Medicine Tracking',
                  style: TextStyle(
                    fontSize: width / 25,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //
                //
                // The Alerts pane
                Container(
                  width: width,
                  height: width / 2.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[600],
                  ),
                  child: CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index, idx) {
                      return car[index];
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: width / 2.3,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.easeInOut,
                      autoPlayAnimationDuration: Duration(
                        milliseconds: 1400,
                      ),
                      autoPlayInterval: Duration(seconds: 5),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                //
                //
                // The first MEDICINE container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 149, 192, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Scan Barcodes to reveal the authenticity of medicine, search for a medicine by name or simply view a list of medicine',
                            style: TextStyle(
                              fontSize: width / 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //
                          //
                          // The buttons
                          Wrap(
                            spacing: 15,
                            children: [
                              //
                              //
                              // The first SCAN BARCODE button
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    checkInternet();
                                    if (con == false) {
                                      _scan();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Turn on internet for this feature');
                                    }
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Image(
                                        width: width / 4.9,
                                        height: width / 4.6,
                                        image: AssetImage(
                                            'assets/icons/user_medicine_container/scanBarcode.png'),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              //
                              //
                              // The second SEARCH MEDICINE Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Search(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
                                      image: AssetImage(
                                          'assets/icons/user_medicine_container/searchMedicine.png'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              //
                              //
                              // The third VIEW MEDICINE BUTTON
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ViewMedicine(
                                        pageName: 'Medicines',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
                                      image: AssetImage(
                                          'assets/icons/user_medicine_container/viewMedicine.png'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              //
                              //
                              // The fourth SCAN FROM GALLERY BARCODE button
                              GestureDetector(
                                onTap: () {
                                  checkInternet();
                                  if (con == false) {
                                    _scanPhoto();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Turn on internet for this feature');
                                  }
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
                                      image: AssetImage(
                                          'assets/icons/user_medicine_container/scanGallery.png'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //
                //
                // The second PHARMACIES AND CLINICS container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pharmacies and Clinics',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'This section is for finding the recommended and trusted pharmacies and clinics. They are recommended by the distributors themselves and thus have no chance of housing fake medicine or malpractice',
                            style: TextStyle(
                              fontSize: width / 30,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //
                          //
                          // The buttons
                          Wrap(
                            spacing: 15,
                            children: [
                              //
                              //
                              // The first VIEW CLINICS button
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Clinics(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Image(
                                        width: width / 4.9,
                                        height: width / 4.6,
                                        image: AssetImage(
                                            'assets/icons/user_pharmacies_clinics/viewClinics.png'),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 149, 192, 255),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              //
                              // The second VIEW PHARMACIES Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Pharmacies(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
                                      image: AssetImage(
                                          'assets/icons/user_pharmacies_clinics/viewPharmacies.png'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 149, 192, 255),
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
                SizedBox(
                  height: 30,
                ),
                //
                //
                // The third EXTRAS container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Extras',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'This sections deals with the extra functionality such as the tips section and the about section of the application',
                            style: TextStyle(
                              fontSize: width / 30,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //
                          //
                          // The buttons
                          Wrap(
                            spacing: 15,
                            children: [
                              //
                              //
                              // The first ABOUT button
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => About(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Image(
                                        width: width / 4.9,
                                        height: width / 4.6,
                                        image: AssetImage(
                                            'assets/icons/user_extras/about.png'),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 149, 192, 255),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              //
                              // The second TIPS Button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Tips(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
                                      image: AssetImage(
                                          'assets/icons/user_extras/tips.png'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 149, 192, 255),
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
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  // The future builder widget thet tells you the number of corona cases
  getWidget() {
    return FutureBuilder<CoronaModel>(
      future: getCases(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cases = snapshot.data;
          final infectedNumber = cases.infected.toString();

          return RichText(
            text: TextSpan(
              text: 'Pakistan: ',
              style: TextStyle(
                fontSize: width / 25,
                fontFamily: 'Montserrat',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: infectedNumber.length >= 4 && infectedNumber.length < 7
                      ? infectedNumber.substring(0, infectedNumber.length - 3) +
                          'k'
                      : infectedNumber.length >= 7
                          ? infectedNumber.substring(
                                  0, infectedNumber.length - 6) +
                              'mil'
                          : infectedNumber,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 24,
                  ),
                ),
                TextSpan(
                  text: ' cases ',
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(
            'Error Loading Widget',
            style: TextStyle(
              fontSize: width / 25,
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          );
        }

        return Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.white30,
          child: Container(
            child: Text(
              'Pakistan: .... cases',
              style: TextStyle(
                fontSize: width / 25,
                fontFamily: 'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
