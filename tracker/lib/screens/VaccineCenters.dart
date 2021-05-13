import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VaccineCenters extends StatefulWidget {
  const VaccineCenters({Key key});

  @override
  _VaccineCentersState createState() => _VaccineCentersState();
}

class _VaccineCentersState extends State<VaccineCenters> {
  double width;
  double height;
  double safePadding;
  String age;
  var vaccinationCenterStream;
  bool con;

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
          age = value.data()['ageForVaccination'];
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // get Corona Centers
  getVaccinationCenters() async {
    try {
      setState(() {
        vaccinationCenterStream = FirebaseFirestore.instance
            .collection('VaccinationCenters')
            .orderBy('name')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
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

  @override
  void initState() {
    super.initState();
    getAlertsInfo();
    getVaccinationCenters();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final safePadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 248),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: _MyHeadDelegate(
                safePadding: safePadding,
                height: height,
                width: width,
                age: age,
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: width / 10,
                    ),
                    Text(
                      'Vaccination Centers',
                      style: TextStyle(
                        fontSize: width / 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),

                    //
                    //
                    // stream builder to get the vaccination centers
                    con == true
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
                            stream: vaccinationCenterStream,
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
                                itemBuilder: (BuildContext context, int index) {
                                  QueryDocumentSnapshot item =
                                      snapshot.data.docs[index];
                                  return Locations(
                                    description: item['address'],
                                    height: height,
                                    title: item['name'],
                                    width: width,
                                    query: item['address'],
                                  );
                                },
                              );
                            }),

                    SizedBox(
                      height: width / 7,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyHeadDelegate extends SliverPersistentHeaderDelegate {
  final double safePadding;
  final double height;
  final double width;
  final String age;

  const _MyHeadDelegate({
    this.safePadding,
    this.height,
    this.width,
    this.age,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double max = width * 1;
    double min = width / 5.5;
    double shrink = (max - shrinkOffset) * (100 / max);
    double shrinkPercent = (1 - shrinkOffset / max);
    double opac = (pow(shrinkPercent, 4)).clamp(0.0, 1.0);
    var shadow = [
      BoxShadow(
        color: Colors.black26,
        spreadRadius: 0,
        blurRadius: 7,
        offset: Offset(
          3,
          3,
        ), // changes position of shadow
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 50, 196, 129).withOpacity(opac),
        image: DecorationImage(
          image: AssetImage('assets/images/vaccineCenter.png'),
          fit: BoxFit.fitWidth,
          colorFilter: new ColorFilter.mode(
            Color.fromARGB(255, 50, 196, 129).withOpacity(opac),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: ((width / 4.5) * shrinkPercent),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 15),
              child: Opacity(
                opacity: opac,
                child: Container(
                  child: futureWidget(
                    age: age,
                    shadow: shadow,
                    shrinkPercent: shrinkPercent,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: ((safePadding * shrinkPercent) + 10)
                .clamp(safePadding + 10, safePadding + 10),
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                  (1 - (shrinkPercent * shrinkPercent)).clamp(0.0, 1.0),
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400].withOpacity(1 - (shrinkPercent)),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: shrinkPercent < 0.75 ? Colors.grey[700] : Colors.white,
                ),
                iconSize:
                    (width / 15 * shrinkPercent).clamp(width / 18, width / 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

//
//
// widget when snapshot.has data
  futureWidget({
    age,
    shadow,
    shrinkPercent,
  }) {
    //
    //
    // The method to send CNIC through sms
    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        Fluttertoast.showToast(msg: 'Could not Launch $command');
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(
              'Vaccine Centers',
              style: TextStyle(
                letterSpacing: -2,
                fontSize: width / 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: width / 25,
          ),
          Container(
            width: width / 2.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: new TextSpan(
                    text: 'Get vaccinated if you are ',
                    style: TextStyle(
                      fontSize: width / 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                        text: '$age',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new TextSpan(text: ' years of age.'),
                    ],
                  ),
                ),
                SizedBox(
                  height: width / 50,
                ),
                Text(
                  'Get the code by sending your CNIC to 1166 or by pressing the button below.',
                  style: TextStyle(
                    fontSize: width / 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: width / 13,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.white54,
              splashColor: Colors.green[100],
              borderRadius: BorderRadius.circular(200),
              onTap: () {
                customLaunch('sms:1166');
              },
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Center(
                    child: Text(
                      'Tap to send CNIC and get code',
                      style: TextStyle(
                        fontSize: width / 29,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ]);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => width * 1;

  @override
  // TODO: implement minExtent
  double get minExtent => width / 5.5;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class Locations extends StatelessWidget {
  final String title;
  final String description;
  final double width;
  final double height;
  final String query;

  const Locations({
    Key key,
    this.title,
    this.description,
    this.width,
    this.height,
    this.query,
  }) : super(key: key);

  //
  //
  // The method to send CNIC through sms
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      Fluttertoast.showToast(msg: 'Could not Launch $command');
    }
  }

  //
  //
  // open maps
  static Future<void> openMap(String query) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${query}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.white54,
          splashColor: Colors.green[100],
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            openMap(query);
          },
          child: Ink(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width / 30,
              vertical: width / 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width / 1.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: width / 24,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 50, 196, 129),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: width / 32,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
