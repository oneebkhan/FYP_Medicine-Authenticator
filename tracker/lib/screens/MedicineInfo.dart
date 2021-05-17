import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MedicineInfo extends StatefulWidget {
  final String medBarcode;
  final String medName;

  MedicineInfo({
    Key key,
    this.medBarcode,
    this.medName,
  }) : super(key: key);

  @override
  _MedicineInfoState createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
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
  var page2 = PageController();
  var med;
  var med1;
  var stream;
  var stream2;
  List<Widget> numberOfImagesIndex;

  //
  //
  // makes a list of widgets for the first page view
  // ignore: missing_return
  Future getImages() {
    for (int i = 0; i < med['imageURL'].length; i++) {
      setState(() {
        numberOfImagesIndex.add(
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  med['imageURL'][i].toString(),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  //
  //
  // gets the firebase data of that particular medicine
  Future getMedicineInfo() async {
    try {
      stream = await FirebaseFirestore.instance
          .collection('Medicine')
          .doc(widget.medBarcode)
          .snapshots()
          .listen((event) {
        setState(() {
          med1 = event.data();
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  Future getMedFromBarcode() async {
    try {
      stream2 = await FirebaseFirestore.instance
          .collection('MedicineModel')
          .doc(widget.medName)
          .snapshots()
          .listen((event) {
        setState(() {
          med = event.data();
          getImages();
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // initial state
  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;
    numberOfImagesIndex = [];
    getMedicineInfo();
    getMedFromBarcode();
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        opac2 = 1.0;
      });
    });
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

  @override
  void dispose() {
    stream.cancel();
    stream2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        floatingActionButton: FloatingActionButton(
          child: Icon(index2 == 0
              ? Icons.keyboard_arrow_down_outlined
              : Icons.keyboard_arrow_up_outlined),
          onPressed: () {
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
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        //
        //
        // Shows a progress indicator if the medicine information is not retrieved
        body: med == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PageView(
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
                      PageView(
                          controller: page2,
                          onPageChanged: (i) {
                            setState(() {
                              index = i;
                            });
                          },
                          children: numberOfImagesIndex == null
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.blue,
                                )
                              : numberOfImagesIndex),
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: width / 1.2,
                                  child: Row(
                                    children: [
                                      Text(
                                        med['name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width / 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      //
                                      //
                                      // The Green tick for medicine authentication
                                      med1['sold'] == null
                                          ? Container()
                                          : Container(
                                              child: Icon(
                                                Icons.check_circle,
                                                size: width / 13,
                                                color: Color.fromARGB(
                                                    255, 130, 255, 159),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //
                              //
                              // indicator of the number of pictures
                              med['imageURL'][0] == null
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 13,
                                            vertical: 10,
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(0),
                                            itemCount: med['imageURL'].length,
                                            itemBuilder: (BuildContext context,
                                                int ind) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.5),
                                                child: Container(
                                                  margin: EdgeInsets.all(0),
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: index == ind
                                                        ? Colors.blue[200]
                                                        : Colors.grey[700],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              //
                              //
                              // shows the price of the medicine
                              med['price'] == null
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Price:',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Rs.' + med['price'].toString(),
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
                              //
                              //
                              // Shows the dosage fo the medicine
                              med['dose'] == null
                                  ? Container()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dose:',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            med['dose'],
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
                    // The bottom page info
                    child: SingleChildScrollView(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              //
                              //
                              // description container
                              Container(
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
                                        'Product Description',
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
                                        med['description'] == null
                                            ? 'N/A'
                                            : med['description'],
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
                              //
                              //
                              // company name container
                              Container(
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
                                        'Company Name',
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
                                        med['companyName'] == null
                                            ? 'N/A'
                                            : med['companyName'],
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

                              //
                              //
                              // barcode and authenticity
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: width / 3.1,
                                      width: width / 2.26,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 50, 50, 50),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Barcode Number',
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
                                              med1['barcode'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width / 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: width / 3.1,
                                      width: width / 2.26,
                                      decoration: BoxDecoration(
                                        color: med1['sold'] == null
                                            ? Color.fromARGB(255, 235, 60, 10)
                                            : Color.fromARGB(
                                                255, 104, 204, 127),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              med1['sold'] == null
                                                  ? Icons.close
                                                  : Icons.check,
                                              color: Colors.white,
                                              size: width / 8,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              med1['sold'] == null
                                                  ? 'Medicine has not been Authenticated'
                                                  : 'Medicine is Authentic',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width / 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //
                              //
                              // What the medicine should be used for
                              Container(
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
                                        'Uses',
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
                                        med['uses'] == null
                                            ? Container()
                                            : med['uses'],
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
                              //
                              //
                              // the side effects of the medicine
                              Container(
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
                                        'Side Effects',
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
                                        med['sideEffects'] == null
                                            ? Container()
                                            : med['sideEffects'],
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
                              //
                              //
                              // the side effects of the medicine
                              Container(
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
                                        'Active Ingredients',
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
                                        med['activeIngredients'] == null
                                            ? Container()
                                            : med['activeIngredients'],
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
                              //
                              //
                              // the side effects of the medicine
                              Container(
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
                                        'Other Ingredients',
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
                                        med['otherIngredients'] == null
                                            ? Container()
                                            : med['otherIngredients'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width / 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'GTIN Number',
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
                                            med1['GTIN'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Batch Number',
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
                                            med1['batchNumber'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Product Number',
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
                                            med1['productNumber'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Batch Status',
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
                                            med1['batchStatus'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Registration Num',
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
                                            med1['regNumber'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width / 2.26,
                                    height: width / 3.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 50, 50, 50),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Registrant',
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
                                            med1['registrant'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Produced On',
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
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(
                                                med1['productionDate'].toDate())
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
                              //
                              //
                              // the side effects of the medicine
                              Container(
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
                                        'Expiry Date',
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
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(med1['expiryDate'].toDate())
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
                              //
                              //
                              // the side effects of the medicine
                              Container(
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
                                        'Sold On',
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
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(med1['sold'].toDate())
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
      ),
    );
  }
}
