import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class Distributor extends StatefulWidget {
  final String dist;

  Distributor({
    Key key,
    @required this.dist,
  }) : super(key: key);

  @override
  _DistributorState createState() => _DistributorState();
}

// ignore: camel_case_types
class _DistributorState extends State<Distributor> {
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
  var info;

  //
  //
  // gets the firebase data of that particular medicine
  getDistributorInfo() async {
    try {
      // ignore: unused_local_variable
      StreamSubscription<DocumentSnapshot> stream = await FirebaseFirestore
          .instance
          .collection('Distributor')
          .doc(widget.dist)
          .snapshots()
          .listen((event) {
        setState(() {
          info = event.data();
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;
    getDistributorInfo();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac2 = 1.0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  //
  //
  // launch google maps
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
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    return info == null
        ? Container(
            color: Colors.black,
            width: width,
            height: height,
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            floatingActionButton: SpeedDial(
              backgroundColor: Colors.blue[500],
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(color: Colors.white),
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  label: 'Delete Distributor',
                  backgroundColor: Colors.blue[500],
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {
                    //openMap(info['location']);
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: 'Contact Distributor',
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.blue[500],
                  onTap: () {
                    //customLaunch('tel:' + info['phoneNumber']);
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: 'Edit Distributor',
                  backgroundColor: Colors.blue[500],
                  labelBackgroundColor: Colors.grey[800],
                  labelStyle: TextStyle(color: Colors.white),
                  onTap: () {},
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
                  backgroundColor: Colors.blue[500],
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
                    // The image behind the info
                    info['image'] == null
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
                                  info['image'] == ''
                                      ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                      : info['image'].toString(),
                                ),
                              ),
                            ),
                          ),
                    //
                    //
                    // The top page info
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
                                    info['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 10,
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
                                      fontSize: width / 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    info['companyName'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 22,
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
                                      fontSize: width / 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    info['sales'].length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 22,
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
                                      fontSize: width / 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    info['email'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 22,
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
                  // The bottom page info
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
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      info['addedByAdmin'] +
                                          ' on ' +
                                          info['dateAdded'].toString(),
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
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      info['phoneNumber'],
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 50, 50, 50),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location: ',
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
                                        info['location'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width / 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //
                            //
                            // To be removed if there is no barcode search
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 50, 50, 50),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pharmacies Added: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    info['pharmacyAdded'].length == 0
                                        ? Text(
                                            'N/A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                info['pharmacyAdded'].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Text(
                                                info['pharmacyAdded'][i],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width / 30,
                                                ),
                                              );
                                            },
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
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Clinics Added: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    info['clinicsAdded'].length == 0
                                        ? Text(
                                            'N/A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                info['clinicsAdded'].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Text(
                                                info['clinicsAdded'][i],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width / 30,
                                                ),
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ),
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
}
