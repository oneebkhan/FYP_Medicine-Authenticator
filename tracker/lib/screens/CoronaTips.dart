import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker/Utils/CoronaModel.dart';
import 'package:shimmer/shimmer.dart';

class CoronaTips extends StatefulWidget {
  const CoronaTips({Key key});

  @override
  _CoronaTipsState createState() => _CoronaTipsState();
}

class _CoronaTipsState extends State<CoronaTips> {
  double width;
  double height;
  double safePadding;
  String alert;
  String alertStatus;
  String alertDescription;

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

  @override
  void initState() {
    super.initState();
    getAlertsInfo();
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
                alert: alert,
                alertDescription: alertDescription,
                alertStatus: alertStatus,
                coronaModel: getCases(),
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
                      'Precautions',
                      style: TextStyle(
                        fontSize: width / 15,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      description:
                          'Use an alcohol-based hand sanitizer that contains at least 60% alcohol, when going out ',
                      height: height,
                      img: 'assets/images/san.png',
                      title: 'Wash and Sanitize Often',
                      titleColor: Color.fromARGB(255, 120, 176, 148),
                      width: width,
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      height: height,
                      width: width,
                      img: 'assets/images/wash.png',
                      title: 'Wash Your Hands Regularly',
                      description:
                          'Make sure to wear a mask at all times to avoid catching or spreading bacteria.',
                      titleColor: Color.fromARGB(255, 204, 178, 165),
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      height: height,
                      width: width,
                      img: 'assets/images/mask.png',
                      title: 'Wear a Mask at All Times',
                      description:
                          'Make sure to wear a mask at all times to avoid catching or spreading bacteria.',
                      titleColor: Color.fromARGB(255, 29, 172, 196),
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      height: height,
                      width: width,
                      img: 'assets/images/distance.png',
                      title: 'Social Distance',
                      description:
                          'Keep at least 6 feet or 2 meters of distance between eachother.',
                      titleColor: Color.fromARGB(255, 195, 112, 42),
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      height: height,
                      width: width,
                      img: 'assets/images/vaccine.png',
                      title: 'Vaccine',
                      description:
                          'Get vaccinated as soon as possible, to keep the chances of you contracting corona to a minimum.',
                      titleColor: Color.fromARGB(255, 174, 212, 90),
                    ),
                    SizedBox(
                      height: width / 15,
                    ),
                    Precautions(
                      height: height,
                      width: width,
                      img: 'assets/images/home.png',
                      title: 'Stay at Home',
                      description:
                          'Keep going out to a minimum and stay at home as much as possible.',
                      titleColor: Color.fromARGB(255, 182, 54, 66),
                    ),
                    SizedBox(
                      height: width / 8,
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
  final String alert;
  final String alertDescription;
  final String alertStatus;
  final Future<CoronaModel> coronaModel;

  const _MyHeadDelegate({
    this.safePadding,
    this.height,
    this.width,
    this.alert,
    this.alertDescription,
    this.alertStatus,
    this.coronaModel,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double max = width * 1.08;
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
        color: Color.fromARGB(255, 228, 89, 86).withOpacity(opac),
        image: DecorationImage(
          image: AssetImage('assets/images/coronaBackground.png'),
          fit: BoxFit.fitWidth,
          colorFilter: new ColorFilter.mode(
            Color.fromARGB(255, 228, 89, 86).withOpacity(opac),
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
                  child: FutureBuilder<CoronaModel>(
                    future: coronaModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final cases = snapshot.data;
                        final infected = cases.infected.toString();
                        final critical = cases.critical.toString();
                        final deceased = cases.deceased.toString();
                        final recovered = cases.critical.toString();
                        return futureWidget(
                          alert: alert,
                          alertStatus: alertStatus,
                          alertDescription: alertDescription,
                          infected: infected,
                          critical: critical,
                          deceased: deceased,
                          recovered: recovered,
                          shadow: shadow,
                          shrinkPercent: shrinkPercent,
                          snapshot: snapshot,
                        );
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.red[300],
                          highlightColor: Colors.red[100],
                          child: Column(
                            children: [
                              Container(
                                width: width / 2,
                                height: width / 10,
                                color: Colors.red,
                              ),
                              SizedBox(height: width / 20),
                              Container(
                                width: width / 2,
                                height: width / 6,
                                color: Colors.red,
                              ),
                              Container(
                                width: width / 2,
                                child: GridView.count(
                                  children: [
                                    Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: width,
                                      height: height,
                                      color: Colors.black,
                                    ),
                                  ],
                                  crossAxisSpacing: width / 30,
                                  mainAxisSpacing: width / 30,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: ((width / 5) / (width / 7)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
  futureWidget(
      {alert,
      alertStatus,
      alertDescription,
      infected,
      critical,
      deceased,
      recovered,
      shadow,
      shrinkPercent,
      snapshot}) {
    Color baseColor = Colors.red[300];
    Color highlightColor = Colors.red[100];
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Text(
              '$alert - $alertStatus',
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
            height: 10,
          ),
          Container(
            width: width / 2.2,
            child: Text(
              '$alertDescription',
              style: TextStyle(
                fontSize: width / 25,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: (width / 1.7) * (shrinkPercent),
            width: width / 1.75,
            child: GridView.count(
              crossAxisSpacing: width / 30,
              mainAxisSpacing: width / 30,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: ((width / 5) / (width / 7)),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadow,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Infected',
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: width / 55),
                        Text(
                          infected.length >= 4 && infected.length < 7
                              ? infected.substring(0, infected.length - 3) + 'k'
                              : infected.length >= 7
                                  ? infected.substring(0, infected.length - 6) +
                                      'mil'
                                  : infected,
                          style: TextStyle(
                            fontSize: width / 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadow,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Critical',
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: width / 55),
                        Text(
                          critical.length >= 4 && critical.length < 7
                              ? critical.substring(0, critical.length - 3) + 'k'
                              : critical.length >= 7
                                  ? critical.substring(0, critical.length - 7) +
                                      'mil'
                                  : critical,
                          style: TextStyle(
                            fontSize: width / 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadow,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deceased',
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: width / 55),
                        Text(
                          deceased.length >= 4 && deceased.length < 7
                              ? deceased.substring(0, deceased.length - 3) + 'k'
                              : deceased.length >= 7
                                  ? deceased.substring(0, deceased.length - 6) +
                                      'mil'
                                  : deceased,
                          style: TextStyle(
                            fontSize: width / 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: shadow,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recovered',
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: width / 55),
                        Text(
                          recovered.length >= 4 && recovered.length < 7
                              ? recovered.substring(0, recovered.length - 3) +
                                  'k'
                              : recovered.length >= 7
                                  ? recovered.substring(
                                          0, recovered.length - 6) +
                                      'mil'
                                  : recovered,
                          style: TextStyle(
                            fontSize: width / 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => width * 1.08;

  @override
  // TODO: implement minExtent
  double get minExtent => width / 5.5;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class Precautions extends StatelessWidget {
  final String img;
  final String title;
  final Color titleColor;
  final String description;
  final double width;
  final double height;

  const Precautions({
    Key key,
    this.img,
    this.title,
    this.description,
    this.width,
    this.height,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: width / 5,
            height: width / 5,
            margin: EdgeInsets.only(left: 15),
            child: Center(
              child: Image(
                image: AssetImage(img),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: width / 2.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width / 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: titleColor,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: width / 35,
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
    );
  }
}
