import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MedicineInfo extends StatefulWidget {
  final String medicineName;

  MedicineInfo({
    Key key,
    this.medicineName,
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
  List<Widget> numberOfImagesIndex;

  //
  //
  // makes a list of widgets for the first page view
  Future getImages() {
    for (int i = 0; i < med['imageURL'].length; i++) {
      setState(() {
        numberOfImagesIndex.add(Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop),
              fit: BoxFit.fitWidth,
              image: CachedNetworkImageProvider(
                med['imageURL'][i].toString(),
              ),
            ),
          ),
        ));
      });
    }
  }

  //
  //
  // gets the firebase data of that particular medicine
  getMedicineInfo() async {
    try {
      StreamSubscription<DocumentSnapshot> stream = await FirebaseFirestore
          .instance
          .collection('Medicine')
          .doc(widget.medicineName)
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
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        getImages();
      });
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        getImages();
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);

    return Scaffold(
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
                            Row(
                              children: [
                                Text(
                                  med['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(
                                  width: 15,
                                ),
                                //
                                //
                                // The Green tick for medicine authentication
                                Container(
                                  child: Icon(
                                    Icons.check_circle,
                                    size: width / 13,
                                    color: Color.fromARGB(255, 130, 255, 159),
                                  ),
                                ),
                              ],
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
                                    child: SizedBox(
                                      height: 10,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(0),
                                        itemCount: med['imageURL'].length,
                                        itemBuilder:
                                            (BuildContext context, int ind) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
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
                                            fontSize: width / 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Rs.' + med['price'].toString(),
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
                                            fontSize: width / 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          med['dose'],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Description',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Company Name',
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
                            // Distributors that sell this medicine
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
                                      'Distributors',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    med['distributors'][0] == null
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
                                                med['distributors'].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Text(
                                                med['distributors'][i],
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
                            //
                            //
                            // recommended pharmacies that have this medicine
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
                                      'Pharmacies with Medicine',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: width / 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    med['pharmaciesList'][0] == null
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
                                                med['pharmaciesList'].length,
                                            itemBuilder:
                                                (BuildContext context, int i) {
                                              return Text(
                                                med['pharmaciesList'][i],
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
                            //
                            //
                            // To be removed if there is no barcode search
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width / 2.3,
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
                                              fontSize: width / 16,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'ABC25678-421',
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
                                    width: width / 2.3,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 104, 204, 127),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: width / 7,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Medicine is Authentic',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Uses',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Side Effects',
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
