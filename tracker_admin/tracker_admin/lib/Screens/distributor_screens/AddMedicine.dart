import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';

// ignore: must_be_immutable
class AddMedicine extends StatefulWidget {
  final String medName;
  final String price;
  final String quantity;
  final String dose;

  const AddMedicine({
    Key key,
    this.medName,
    this.price,
    this.quantity,
    this.dose,
  }) : super(key: key);

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  double width;
  double height;
  double safePadding;
  TextEditingController medName = TextEditingController();
  TextEditingController gtin = TextEditingController();
  TextEditingController barcode = TextEditingController();
  TextEditingController batchNumber = TextEditingController();
  TextEditingController bacthStatus = TextEditingController();
  TextEditingController productNumber = TextEditingController();
  TextEditingController registrant = TextEditingController();
  TextEditingController regNumber = TextEditingController();
  String currentDistributorEmail;
  bool _isLoading = false;
  bool con = true;
  var subscription;
  String distributorEmail;
  int index;
  int index2;
  var info;
  DateTime productionDateTime = DateTime.now();
  DateTime expiryDateTime = DateTime.now();

  //
  //
  //get Distributor
  getDistributor() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        info = value.data();
      });
    });
  }

  //
  //
  //check  the internet connectivity
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
  // this function adds distributor information to Firebase Firestore
  addMedicineInfo() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("Medicine").doc(medName.text).set({
        "name": medName.text,
        "GTIN": gtin.text,
        "barcode": barcode.text,
        "batchNumber": batchNumber.text,
        "batchStatus": bacthStatus.text,
        "expiryDate": expiryDateTime,
        "productionDate": productionDateTime,
        "productNumber": productNumber.text,
        "regNumber": regNumber.text,
        "soldBy": '',
        "addedBy": info['email'],
        "registrant": registrant.text,
        "soldAt": '',
        "sold": '',
      }).then((_) async {
        var fire = await FirebaseFirestore.instance;
        fire.collection("History").doc(DateTime.now().toString()).set({
          "timestamp": DateTime.now(),
          "by": info['email'],
          "byCompany": info['companyName'],
          "image": info['image'],
          "name": 'Addition of ' + medName.text + ' model',
          "category": 'Distributor',
        });
        Fluttertoast.showToast(msg: 'Medicine Model created Succesfully!');
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

  checkForMed() async {
    var fire = await FirebaseFirestore.instance
        .collection('Medicine')
        .doc(medName.text)
        .get()
        .then((value) {
      if (value.data().toString() == 'null') {
        addMedicineInfo();
        return null;
      } else {
        Fluttertoast.showToast(
            msg: 'Medicine with same barcode already present!');
        return null;
      }
    });
  }

  //
  //
  //Date time picker to pick date time for expiry and production
  pickExpiryDate() async {
    final DateTime expiryDateSelected = await showDatePicker(
      context: context,
      initialDate: expiryDateTime, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2060),
      helpText: 'Select an Expiry Date',
    );
    if (expiryDateSelected != null && expiryDateSelected != expiryDateTime)
      setState(() {
        expiryDateTime = expiryDateSelected;
      });
  }

  pickProductionDate() async {
    final DateTime productionDateSelected = await showDatePicker(
      context: context,
      initialDate: productionDateTime, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2060),
      helpText: 'Select a Production Date',
    );
    if (productionDateSelected != null &&
        productionDateSelected != productionDateTime)
      setState(() {
        productionDateTime = productionDateSelected;
      });
  }

  @override
  void initState() {
    super.initState();
    getDistributor();
    index2 = 0;
    index = 0;
    distributorEmail = FirebaseAuth.instance.currentUser.email;
    checkInternet();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
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
                                'Add Medicine Info',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              ContainerText(
                                enabled: false,
                                node: node,
                                hint: widget.medName,
                                controller: medName,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dose:',
                                          style: TextStyle(
                                            fontSize: width / 28,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        ContainerText(
                                          enabled: false,
                                          node: node,
                                          hint: widget.dose,
                                          maxLength: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price:',
                                          style: TextStyle(
                                            fontSize: width / 28,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        ContainerText(
                                          enabled: false,
                                          node: node,
                                          hint: 'Rs. ' + widget.price,
                                          maxLength: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Quanity:',
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              ContainerText(
                                enabled: false,
                                node: node,
                                hint: widget.quantity,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ContainerText(
                                hint: 'Barcode/QR code',
                                controller: barcode,
                                node: node,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'GTIN',
                                controller: gtin,
                                node: node,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Batch Number',
                                node: node,
                                controller: batchNumber,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Batch Status',
                                node: node,
                                controller: bacthStatus,
                                maxLength: 40,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Production Number',
                                node: node,
                                controller: productNumber,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Registration Number',
                                node: node,
                                controller: regNumber,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Registrant',
                                node: node,
                                controller: registrant,
                                maxLength: 50,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Pick Expiry Date:',
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  pickExpiryDate();
                                },
                                child: ContainerText(
                                  enabled: false,
                                  node: node,
                                  nextFocus: true,
                                  hint: DateFormat.yMMM()
                                      .format(expiryDateTime)
                                      .toString(),
                                  maxLength: 30,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Pick Production Date:',
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  pickProductionDate();
                                },
                                child: ContainerText(
                                  nextFocus: true,
                                  enabled: false,
                                  node: node,
                                  hint: DateFormat.yMMM()
                                      .format(productionDateTime)
                                      .toString(),
                                  maxLength: 30,
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
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        if (con == true) {
                          Fluttertoast.showToast(
                              msg: 'No internet connection!');
                        } else if (medName.text.isEmpty ||
                            bacthStatus.text.isEmpty ||
                            barcode.text.isEmpty ||
                            batchNumber.text.isEmpty ||
                            expiryDateTime == productionDateTime ||
                            gtin.text.isEmpty ||
                            productNumber.text.isEmpty ||
                            regNumber.text.isEmpty ||
                            registrant.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else {
                          checkForMed();
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
