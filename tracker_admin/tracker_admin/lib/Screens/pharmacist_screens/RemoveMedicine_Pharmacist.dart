import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';
import 'package:tracker_admin/screens/admin_screens/Distributor.dart';
import 'package:tracker_admin/screens/distributor_screens/AddMedicine.dart';

class RemoveMedicine_Pharmacist extends StatefulWidget {
  final List availableMedicine;

  RemoveMedicine_Pharmacist({
    Key key,
    this.availableMedicine,
  }) : super(key: key);

  @override
  _RemoveMedicine_PharmacistState createState() =>
      _RemoveMedicine_PharmacistState();
}

class _RemoveMedicine_PharmacistState extends State<RemoveMedicine_Pharmacist> {
  double opac;
  TextEditingController search = TextEditingController();
  var snapshotData;
  double height;
  bool isSearched;
  bool isLoading;
  var snap;
  String hello = '';
  bool con;
  var pharmacistInfo;
  var pharmacyInfo;
  List medicineList = [];
  String myPharmacy;

  //
  //
  //Check internet connection
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.toString());
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
  // get medicine data
  Future queryData(String queryString) async {
    setState(() {
      snap = FirebaseFirestore.instance
          .collection('MedicineModel')
          .where('name', whereIn: widget.availableMedicine)
          .snapshots();
    });
  }

  //
  //
  //get current pharmacist info
  getPharmacistInfo() async {
    await FirebaseFirestore.instance
        .collection('Pharmacist')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        pharmacistInfo = value.data();
        myPharmacy = value.data()['PharmacyID'];
      });
      getPharmacyInfo();
    });
  }

  //
  //
  //
  getPharmacyInfo() async {
    FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(pharmacistInfo['pharmacyID'])
        .get()
        .then((value) {
      setState(() {
        pharmacyInfo = value.data();
        medicineList = pharmacyInfo['availableMedicine'];
      });
    });
  }

  //
  //
  //add medicine to pharmacy
  removeMedicineFromPharmacy({medList, medName}) async {
    FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(pharmacistInfo['pharmacyID'])
        .update({
      "availableMedicine": medList,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("History")
          .doc(DateTime.now().toString())
          .set({
        "timestamp": DateTime.now(),
        "by": pharmacistInfo['email'],
        "byCompany": pharmacistInfo['companyName'],
        "image": pharmacistInfo['image'],
        "name": medName +
            ' now removed by ' +
            pharmacistInfo['email'] +
            ' from ' +
            pharmacistInfo['pharmacyName'],
        "category": 'pharmacist',
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPharmacistInfo();
    opac = 0;
    isSearched = false;
    isLoading = false;
    snapshotData = null;
    checkInternet();
    search.addListener(() {
      setState(() {
        hello = search.text;
      });
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                      'Select Medicine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 14,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContainerText(
                          node: node,
                          hint: 'Medicine Name',
                          controller: search,
                          maxLines: 1,
                          width: width / 1.4,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: width / 7,
                            width: width / 7,
                            child: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                checkInternet();
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (search.text == null || search.text == '') {
                                } else {
                                  setState(() {
                                    isLoading = true;
                                    isSearched = true;
                                  });
                                  queryData(search.text.toUpperCase())
                                      .whenComplete(() {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                            ),
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
                    con == true
                        ? Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: height / 4.5),
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                left: 20,
                                right: 20,
                                top: 20,
                              ),
                              child: isSearched == false
                                  ? Padding(
                                      padding: EdgeInsets.only(top: width / 2),
                                      child: Center(
                                        child: Container(
                                          child: Text(
                                            'Search for a Medicine\nFor the results to appear here',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : StreamBuilder<QuerySnapshot>(
                                      stream: snap,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData == false) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot
                                                        .data.docs.length >
                                                    6
                                                ? 6
                                                : snapshot.data.docs
                                                    .length, //snapshotData.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              QueryDocumentSnapshot item =
                                                  snapshot.data.docs[index];
                                              if (item['name']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      hello.toLowerCase())) {
                                                return RowInfo(
                                                  imageURL: item['imageURL'][0],
                                                  location: item['dose'] +
                                                      ' - ' +
                                                      item['quantity'],
                                                  width: width,
                                                  title: item['name'],
                                                  func: () {
                                                    if (medicineList.contains(
                                                            item['name']) !=
                                                        true) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Medicine not present in pharmacy');
                                                    } else {
                                                      setState(() {
                                                        medicineList.remove(
                                                            item['name']);
                                                      });
                                                      removeMedicineFromPharmacy(
                                                          medList: medicineList,
                                                          medName:
                                                              item['name']);
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Medicine removed from pharmacy');
                                                    }
                                                  },
                                                );
                                              } else {
                                                return Container();
                                              }
                                            });
                                      },
                                    ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
