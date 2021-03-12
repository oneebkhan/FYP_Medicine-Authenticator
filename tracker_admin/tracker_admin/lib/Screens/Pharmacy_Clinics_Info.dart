import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Pharmacy_Clinics_Info extends StatefulWidget {
  final String name;
  final List<String> imageUrls;
  final String location;
  // latitude and logitude
  final String gps;
  final int cellNumber;
  final String company;
  final List<String> employee;
  final String timings;
  final int review;

  Pharmacy_Clinics_Info({
    Key key,
    this.imageUrls,
    this.company,
    this.name,
    this.location,
    this.gps,
    this.cellNumber,
    this.review,
    this.employee,
    this.timings,
  }) : super(key: key);

  @override
  _Pharmacy_Clinics_InfoState createState() => _Pharmacy_Clinics_InfoState();
}

class _Pharmacy_Clinics_InfoState extends State<Pharmacy_Clinics_Info> {
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

  @override
  void initState() {
    super.initState();
    opac = 0;
    opac2 = 0;
    index = 0;
    index2 = 0;

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        opac = 1.0;
      });
    });
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    page = PageController(initialPage: 0);
    page2 = PageController(initialPage: 0);
    return Scaffold(
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
            label: 'Go to Location',
            backgroundColor: Colors.blue[500],
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            label: 'Edit Info',
            backgroundColor: Colors.blue[500],
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
            label: index2 == 0 ? 'Go to Next Page' : 'Go to Previous Page',
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
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opac,
                child: PageView(
                  controller: page2,
                  onPageChanged: (i) {
                    setState(() {
                      index = i;
                    });
                  },
                  children: [
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            'https://www.localguidesconnect.com/t5/image/serverpage/image-id/514546i92C317AC7411A8F0/image-size/medium?v=1.0&px=400',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.4), BlendMode.dstATop),
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            'https://pharmsci.uci.edu/wp-content/uploads/2020/12/Screen-Shot-2020-12-14-at-9.04.57-AM.png',
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              'Mahtab Pharmacy',
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
                        height: 5,
                      ),
                      //
                      //
                      // indicator of the number of pictures
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 10,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: (2),
                            itemBuilder: (BuildContext context, int ind) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Phase 1, Plot No, 23, Sector F Commercial Area Sector F',
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
                              'Phone Number:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '04235897071',
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
                                'Pharmacy Location',
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
                                'Pharmacy is located in  Phase 1, Plot No, 23, Sector F Commercial Area Sector F Dha Phase 1, Lahore, Punjab',
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
                                'Mahtab, Pakistan',
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
                                'Notable Employees',
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
                                'Marham, Psychologist',
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
                      // To be removed if there is no barcode search
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 110,
                              width: width / 2.3,
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
                                      'Timings',
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
                                      '24/7',
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
                              height: 110,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 254, 192, 70),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: width / 6,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '5/5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
