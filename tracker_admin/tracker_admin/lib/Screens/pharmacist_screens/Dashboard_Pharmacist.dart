import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartWeekly.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartDaily.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartMonthly_Distributor.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartWeekly_Distributor.dart';
import 'package:tracker_admin/Widgets/PopupCard.dart';
import 'package:tracker_admin/Widgets/PopupCard_Pharmacist.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/configs/HeroDialogRoute.dart';
import 'package:tracker_admin/screens/StartingPage.dart';
import 'package:tracker_admin/screens/distributor_screens/Requests.dart';
import 'package:tracker_admin/screens/ViewMedicine.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:tracker_admin/screens/pharmacist_screens/AddMedicine_Pharmacist.dart';
import 'package:tracker_admin/screens/pharmacist_screens/PharmacistHistory.dart';
import 'package:tracker_admin/screens/pharmacist_screens/PharmacyMedicine.dart';
import 'package:tracker_admin/screens/pharmacist_screens/RemoveMedicine_Pharmacist.dart';

class Dashboard_Pharmacist extends StatefulWidget {
  Dashboard_Pharmacist({Key key}) : super(key: key);

  @override
  _Dashboard_PharmacistState createState() => _Dashboard_PharmacistState();
}

class _Dashboard_PharmacistState extends State<Dashboard_Pharmacist> {
  double width;
  double height;
  double density;
  double safePadding;
  int index;
  Color col = Colors.red[400];
  Color floatingButtonColor = Colors.red[400];
  int selectedIndex;
  var page = PageController(initialPage: 0);
  int autheticMedCount;
  int medCount;
  int myAutheticMedCount;
  bool con;
  var subscription;
  var medID;
  var medName;
  var pharmacistStream;
  bool _isLoading = false;
  int pharmacistSalesNumber;
  List pharmacistSalesID;
  List medicineInPharmacy;

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
  // Sign out and go to starting page
  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'Pharmacist Signed Out');
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartingPage(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // emties the med ID after the medicine info page is opened
  nullTheMed() {
    setState(() {
      _isLoading = true;
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
        var barcodeMed =
            FirebaseFirestore.instance.collection("Medicine").doc(barcode);
        barcodeMed.get().then((value) {
          if (value.data()['soldBy'] == '') {
            setState(() {
              pharmacistSalesID.add(medID);
            });
            barcodeMed.update({
              "soldBy": FirebaseAuth.instance.currentUser.email,
              "sold": DateTime.now(),
              "soldAt": pharmacistStream['pharmacyLocation'],
              "soldAtPharmacyID": pharmacistStream['pharmacyID'],
            }).then((value) {
              updateHistory();
            });
          } else {
            Fluttertoast.showToast(msg: 'Medicine already sold');
          }
        });
      }
      setState(() {
        _isLoading = false;
      });
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
        var barcodeMed =
            FirebaseFirestore.instance.collection("Medicine").doc(barcode);
        barcodeMed.get().then((value) {
          if (value.data()['soldBy'] == '') {
            setState(() {
              pharmacistSalesID.add(medID);
            });
            barcodeMed.update({
              "soldBy": FirebaseAuth.instance.currentUser.email,
              "sold": DateTime.now(),
              "soldAt": pharmacistStream['pharmacyLocation'],
              "soldAtPharmacyID": pharmacistStream['pharmacyID'],
            }).then((value) {
              updateHistory();
            });
          } else {
            Fluttertoast.showToast(msg: 'Medicine already sold');
          }
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  //update History
  updateHistory() {
    var fire = FirebaseFirestore.instance;
    fire.collection('History').doc(DateTime.now().toString()).set({
      "timestamp": DateTime.now(),
      "by": FirebaseAuth.instance.currentUser.email,
      "byCompany": pharmacistStream['companyName'],
      "image": pharmacistStream['image'],
      "name": medID + ' - ' + medName + ' sold and authenticated',
      "category": 'pharmacist',
    }).then((value) {
      FirebaseFirestore.instance
          .collection('Sales')
          .doc(DateTime.now().toString())
          .set({
        "by": FirebaseAuth.instance.currentUser.email,
        "medicineID": medID,
        "medicineModel": medName,
        "timestamp": DateTime.now(),
        "under": pharmacistStream['addedBy'].keys.toList()[0].toString(),
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Pharmacist')
            .doc(FirebaseAuth.instance.currentUser.email)
            .update({
          "saleID": pharmacistSalesID,
          "salesNumber": pharmacistSalesNumber + 1,
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    });
  }

  //
  //
  // FUNCTION TO GET THE AUTHENTIC MEDICINE COUNT
  getAuthenticMedicine() async {
    try {
      FirebaseFirestore.instance
          .collection('Medicine')
          .snapshots()
          .listen((event) {
        setState(() {
          autheticMedCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE MEDICINE COUNT
  getMedicine() async {
    try {
      FirebaseFirestore.instance
          .collection('MedicineModel')
          .snapshots()
          .listen((event) {
        setState(() {
          medCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE MEDICINE COUNT
  getMyAuthenticMedicine() async {
    try {
      FirebaseFirestore.instance
          .collection('Medicine')
          .where('soldBy', isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots()
          .listen((event) {
        setState(() {
          myAutheticMedCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  getPharmacistData() async {
    FirebaseFirestore.instance
        .collection("Pharmacist")
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        pharmacistStream = value.data();
        pharmacistSalesID = value.data()['saleID'];
        pharmacistSalesNumber = value.data()['salesNumber'];
      });
      getPharmacyInfo();
    });
  }

  getPharmacyInfo() async {
    FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(pharmacistStream['pharmacyID'])
        .get()
        .then((value) {
      setState(() {
        medicineInPharmacy = value.data()['availableMedicine'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    medID = '';
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
    getPharmacistData();
    checkInternet();
    getMedicine();
    getAuthenticMedicine();
    getMyAuthenticMedicine();
    index = 0;
    selectedIndex = 0;
  }

  void dispose() {
    super.dispose();
  }

//
//
// The main widget and the bottom navigation bar
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Close Dashboard?'),
            content: Text(
                'Closing the dashboard means you will be logged out of your account'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  signOut();
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 246, 246, 248),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: PharmacistDashboard(
            width: width,
            height: height,
            authenticMedCount: autheticMedCount,
            medCount: medCount,
            myAutheticMedCount: myAutheticMedCount,
            scan: _scan,
            scanGallery: _scanPhoto,
            medicineInPharmacy: medicineInPharmacy,
            compName: pharmacistStream == null
                ? '!'
                : pharmacistStream['companyName'],
            medicineInPharmacyCount:
                medicineInPharmacy == null ? 0 : medicineInPharmacy.length,
          ),
        ),
      ),
    );
  }
}

//
//
//
// The Dhasboard part of the admin console
class PharmacistDashboard extends StatefulWidget {
  final double width;
  final double height;
  final int medCount;
  final int authenticMedCount;
  final int myAutheticMedCount;
  Function scan;
  Function scanGallery;
  final List medicineInPharmacy;
  final int medicineInPharmacyCount;
  final String compName;

  PharmacistDashboard({
    Key key,
    @required this.width,
    @required this.height,
    this.medCount,
    this.authenticMedCount,
    this.myAutheticMedCount,
    this.scan,
    this.scanGallery,
    this.medicineInPharmacy,
    this.compName,
    this.medicineInPharmacyCount,
  }) : super(key: key);

  @override
  _PharmacistDashboardState createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> {
  Color col = Colors.red[400];
  bool con;
  var historyStream;
  var subscription;

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

  getHistory() async {
    try {
      setState(() {
        historyStream = FirebaseFirestore.instance
            .collection('History')
            .where('category', isEqualTo: 'pharmacist')
            .where('byCompany', isEqualTo: widget.compName)
            .orderBy('timestamp', descending: true)
            .limit(5)
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    Future.delayed(Duration(milliseconds: 1000), () {
      getHistory();
    });

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.width / 15,
          left: 20,
          right: 20,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              //
              // The top title and the notification row
              Center(
                child: Text(
                  'DASHBOARD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.width / 17,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //
              //
              // The first Distributor Container
              Center(
                child: Container(
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
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
                            fontSize: widget.width / 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Authenticated Medicine:',
                              style: TextStyle(
                                fontSize: widget.width / 30,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Container(
                              width: widget.width / 15,
                              height: widget.width / 20,
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.authenticMedCount.toString() == 'null'
                                      ? '!'
                                      : widget.authenticMedCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.width / 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Medicine:',
                              style: TextStyle(
                                fontSize: widget.width / 30,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Container(
                              width: widget.width / 15,
                              height: widget.width / 20,
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.medCount.toString() == 'null'
                                      ? '!'
                                      : widget.medCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.width / 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Authenticated Medicine:',
                              style: TextStyle(
                                fontSize: widget.width / 30,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Container(
                              width: widget.width / 15,
                              height: widget.width / 20,
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.myAutheticMedCount.toString() == 'null'
                                      ? '!'
                                      : widget.myAutheticMedCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.width / 30,
                                  ),
                                ),
                              ),
                            )
                          ],
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
                            // The first ADD DISTRIBUTOR button
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  widget.scan();
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: widget.width / 4.9,
                                      height: widget.width / 4.6,
                                      image: AssetImage(
                                        'assets/icons/pharmacy_dashboard_medicine/authenticateMedicine.png',
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: col,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.scanGallery();
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Image(
                                    width: widget.width / 4.9,
                                    height: widget.width / 4.6,
                                    image: AssetImage(
                                      'assets/icons/pharmacy_dashboard_medicine/scan.png',
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: col,
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
                height: 35,
              ),
              //
              //
              // The first Distributor Container
              Center(
                child: Container(
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pharmacy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.width / 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Medicine In Pharmacy:',
                              style: TextStyle(
                                fontSize: widget.width / 30,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Container(
                              width: widget.width / 15,
                              height: widget.width / 20,
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  widget.medicineInPharmacyCount.toString() ==
                                          'null'
                                      ? '!'
                                      : widget.medicineInPharmacyCount
                                          .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.width / 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(
                          height: 25,
                        ),
                        //
                        //
                        // The buttons
                        Wrap(
                          spacing: 15,
                          children: [
                            //
                            //
                            // The first ADD DISTRIBUTOR button
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddMedicine_Pharmacist(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: widget.width / 4.9,
                                      height: widget.width / 4.6,
                                      image: AssetImage(
                                        'assets/icons/pharmacy_dashboard_medicine/addMedicine.png',
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: col,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PharmacyMedicine(
                                      pageName: 'Medicine in Pharmacy',
                                      availableMedicine:
                                          widget.medicineInPharmacy,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Image(
                                    width: widget.width / 4.9,
                                    height: widget.width / 4.6,
                                    image: AssetImage(
                                      'assets/icons/pharmacy_dashboard_medicine/viewMedicine.png',
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: col,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RemoveMedicine_Pharmacist(
                                      availableMedicine:
                                          widget.medicineInPharmacy,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Image(
                                    width: widget.width / 4.9,
                                    height: widget.width / 4.6,
                                    image: AssetImage(
                                      'assets/icons/pharmacy_dashboard_medicine/removeMedicine.png',
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: col,
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
                height: 35,
              ),
              //
              //
              // The History pane
              Center(
                child: Container(
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: con == true ? Colors.grey[200] : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'History',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.width / 16,
                              ),
                            ),
                            Container(
                              width: 65,
                              height: 30,
                              decoration: BoxDecoration(
                                color: col,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    EdgeInsets.all(0),
                                  ),
                                  textStyle:
                                      MaterialStateProperty.all<TextStyle>(
                                    TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PharmacistHistory(
                                        compName: widget.compName,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'View All',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: widget.height / 40,
                        ),
                        con == true
                            ? Center(
                                child: Container(
                                  width: widget.width / 6,
                                  height: widget.width / 6,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: historyStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      QueryDocumentSnapshot item =
                                          snapshot.data.docs[index];
                                      return Hero(
                                        tag: item['timestamp'].toString(),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                          child: RowInfo(
                                            imageURL: item['image'] == ''
                                                ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                                : item['image'],
                                            location: DateFormat.yMMMd()
                                                .add_jm()
                                                .format(
                                                    item['timestamp'].toDate()),
                                            width: widget.width,
                                            title: item['name'],
                                            func: () {
                                              Navigator.of(context).push(
                                                  HeroDialogRoute(
                                                      builder: (context) {
                                                return PopupCard_Pharmacist(
                                                  tag: item['timestamp']
                                                      .toString(),
                                                  by: item['by'].toString(),
                                                  dateTime: DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(item['timestamp']
                                                          .toDate())
                                                      .toString(),
                                                  image: item['image'],
                                                  name: item['name'],
                                                );
                                              }));
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
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
    );
  }
}
