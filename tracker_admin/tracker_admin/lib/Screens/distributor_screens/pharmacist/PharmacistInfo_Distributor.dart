import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_admin/screens/admin_screens/EditDistributor.dart';
import 'package:tracker_admin/screens/distributor_screens/pharmacist/EditPharmacist.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class PharmacistsInfo_Distributor extends StatefulWidget {
  final String pharm;
  final String pharmacyID;

  PharmacistsInfo_Distributor({
    Key key,
    @required this.pharm,
    this.pharmacyID,
  }) : super(key: key);

  @override
  _PharmacistsInfo_DistributorState createState() =>
      _PharmacistsInfo_DistributorState();
}

// ignore: camel_case_types
class _PharmacistsInfo_DistributorState
    extends State<PharmacistsInfo_Distributor> {
  double width;
  double height;
  double safePadding;
  //opacity of the normal text
  double opac;
  //opacity of the image;
  double opac2;
  int index;
  int index2;

  var page = PageController();
  var pharmacistStream;
  bool pass = false;
  var distributorStream;
  List pharmacistsList;

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
        distributorStream = value.data();
      });
    });
  }

  //
  //
  // get pharmacy
  getPharmacy() async {
    await FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(widget.pharmacyID)
        .get()
        .then((value) {
      setState(() {
        pharmacistsList = value.data()['employees'];
      });
    });
  }

  //
  //
  // gets the firebase data of that particular distributor
  getPharmacistInfo() async {
    try {
      // ignore: unused_local_variable
      var stream = await FirebaseFirestore.instance
          .collection('Pharmacist')
          .doc(widget.pharm)
          .snapshots()
          .listen((event) {
        setState(() {
          pharmacistStream = event.data();
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  updateHistory() async {
    var fire = await FirebaseFirestore.instance;
    fire.collection("History").doc(DateTime.now().toString()).set({
      "timestamp": DateTime.now(),
      "by": distributorStream['email'],
      "byCompany": distributorStream['companyName'],
      "image": distributorStream['image'],
      "name": pharmacistStream['name'] + ' deleted',
      "category": 'distributor',
    });
  }

  @override
  void initState() {
    super.initState();
    getPharmacistInfo();
    getDistributor();
    getPharmacy();
    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  //
  //
  // Delete the user folder contents in firebase storage
  deleteFolderContents(query) {
    String path = "Pharmacist/" + "$query";
    var ref = FirebaseStorage.instance.ref(path);

    ref.listAll().then((dir) {
      dir.items.forEach((fileRef) {
        this.deleteFile(ref.fullPath, fileRef.name);
      });
      dir.prefixes.forEach((folderRef) {
        this.deleteFolderContents(folderRef.fullPath);
      });
    }).catchError((error) => Fluttertoast.showToast(msg: "$error"));
  }

  deleteFile(pathToFile, fileName) {
    var ref = FirebaseStorage.instance.ref(pathToFile);
    var childRef = ref.child(fileName);
    childRef.delete();
  }

  //
  //
  //delete distributor firestore document
  deletePharmacist() async {
    FirebaseFirestore.instance
        .collection("Pharmacy")
        .doc(pharmacistStream['pharmacyID'])
        .update({
      "employees": pharmacistsList,
    }).then((value) async {
      FirebaseFirestore.instance
          .collection('Pharmacist')
          .doc(pharmacistStream['email'])
          .delete()
          .catchError((error) => print("Failed to delete user: $error"));
    });
  }

  //
  //
  // unregister firebase auth
  unregisterPharmacist() async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      var result = await FirebaseAuth.instanceFor(app: app)
          .currentUser
          .reauthenticateWithCredential(EmailAuthProvider.credential(
              email: pharmacistStream['email'],
              password: pharmacistStream['password']));
      result.user.delete();
      print('test');
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
      print(e);
    }
    await app.delete();
  }

  //
  //
  // These two functions make the page scroll up even when the page has a singlechildscrollview
  _scrollUp() async {
    await page.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  _scrollDown() async {
    await page.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  //
  //
  // The method to call the pharmacy or clinic
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      Fluttertoast.showToast(msg: 'Could not Launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    return pharmacistStream == null
        ? Container(
            color: Colors.black,
            width: width,
            height: height,
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            floatingActionButton: SpeedDial(
              backgroundColor: Color.fromARGB(255, 148, 210, 146),
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(color: Colors.white),
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: 'Delete Pharmacist',
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete ' + pharmacistStream['name'] + '?'),
                        content: Text(
                            'This will delete the pharmacist and the associated images folder'),
                        actions: [
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                pharmacistsList
                                    .remove(pharmacistStream['email']);
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => customAlert());
                              updateHistory();
                              deleteFolderContents(
                                pharmacistStream['email'],
                              );
                              unregisterPharmacist();
                              Future.delayed(Duration(milliseconds: 2100), () {
                                deletePharmacist();
                                Navigator.pop(context);
                                //Navigator.pop(context);
                              });
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
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: 'Call Pharmacist',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  onTap: () {
                    customLaunch('tel:' + pharmacistStream['phoneNumber']);
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: 'Email Pharmacist',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  onTap: () {
                    customLaunch('mailto:${pharmacistStream['email']}');
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: 'Edit Pharmacist',
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPharmacist(
                          email: pharmacistStream['email'],
                          name: pharmacistStream['name'],
                          phoneNumber: pharmacistStream['phoneNumber'],
                          image: pharmacistStream['image'],
                        ),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    index2 == 0
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up_outlined,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (index2 == 1) {
                      page.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      page.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  backgroundColor: Color.fromARGB(255, 148, 210, 146),
                  label:
                      index2 == 0 ? 'Go to Next Page' : 'Go to Previous Page',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            body: PageView(
              scrollDirection: Axis.vertical,
              controller: page,
              onPageChanged: (i) {
                setState(() {
                  index2 = i;
                });
              },
              children: [
                Stack(
                  children: [
                    //
                    //
                    // The image behind the pharmacistStream
                    pharmacistStream['image'] == null
                        ? Center(
                            child: Container(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator()),
                          )
                        : Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop),
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  pharmacistStream['image'] == '' ||
                                          pharmacistStream['image'] == null
                                      ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                      : pharmacistStream['image'].toString(),
                                ),
                              ),
                            ),
                          ),
                    //
                    //
                    // The top page pharmacistStream
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: opac2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: width / 1.2,
                                  child: Text(
                                    pharmacistStream['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Company: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    pharmacistStream['companyName'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 27,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sales: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    pharmacistStream['salesNumber'].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 27,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    pharmacistStream['email'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 27,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: width / 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //
                //
                // function to allow for scroll in the single child scroll view
                NotificationListener(
                  onNotification: (notification) {
                    if (notification is OverscrollNotification) {
                      if (notification.overscroll > 0) {
                        _scrollDown();
                      } else {
                        _scrollUp();
                      }
                    }
                  },
                  //
                  //
                  // The bottom page pharmacistStream
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Added By: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      pharmacistStream['addedBy']
                                              .keys
                                              .toList()[0]
                                              .toString() +
                                          ' - ' +
                                          DateFormat.yMMMd()
                                              .add_jm()
                                              .format(
                                                  pharmacistStream['addedBy'][
                                                          pharmacistStream[
                                                                  'addedBy']
                                                              .keys
                                                              .toList()[0]
                                                              .toString()]
                                                      .toDate())
                                              .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      pharmacistStream['phoneNumber'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: width / 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  //
  //
  //custom alert dialogue
  customAlert() {
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.pop(context);
      //Navigator.pop(context);
    });
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: width / 4,
                child: Lottie.asset(
                  'assets/lottie/deletedSuccessfully.json',
                  frameRate: FrameRate(144),
                  repeat: false,
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            Container(
              child: Text(
                'Pharmacist Deleted Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
