import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartWeekly.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartDaily.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/AddDistributor.dart';
import 'package:tracker_admin/screens/Clinic/DistributorClinics.dart';
import 'package:tracker_admin/screens/ContactDevs.dart';
import 'package:tracker_admin/screens/Pharmacy/DistributorPharmacies.dart';
import 'package:tracker_admin/screens/ViewMedicine.dart';

class Dashboard_Admin extends StatefulWidget {
  @override
  _Dashboard_AdminState createState() => _Dashboard_AdminState();
}

class _Dashboard_AdminState extends State<Dashboard_Admin> {
  double width;
  double height;
  double density;
  double safePadding;
  int index;
  Color col = Color.fromARGB(255, 149, 191, 255);
  Color floatingButtonColor;
  int selectedIndex;
  int count;
  int medCount;
  int pharmCount;
  int clinicCount;
  int distributorCount;
  double opac;
  double opac2;

  //
  //
  // FUNCTION TO GET THE REQUESTS STREAM
  getDevRequests() async {
    try {
      FirebaseFirestore.instance
          .collection('ContactDevelopers')
          .snapshots()
          .listen((event) {
        setState(() {
          count = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE DISTRIBUTOR COUNT
  getDistributors() async {
    try {
      FirebaseFirestore.instance
          .collection('Distributor')
          .snapshots()
          .listen((event) {
        setState(() {
          distributorCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE PHARMACY COUNT
  getPharmacy() async {
    try {
      FirebaseFirestore.instance
          .collection('Pharmacy')
          .snapshots()
          .listen((event) {
        setState(() {
          pharmCount = event.docs.length;
        });
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // FUNCTION TO GET THE CLINIC COUNT
  getClinic() async {
    try {
      FirebaseFirestore.instance
          .collection('Clinic')
          .snapshots()
          .listen((event) {
        setState(() {
          clinicCount = event.docs.length;
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
          .collection('Medicine')
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

  @override
  void initState() {
    super.initState();
    index = 0;
    selectedIndex = 0;
    opac = 1;
    opac2 = 0;
    floatingButtonColor = Color.fromARGB(255, 130, 150, 250);
    getDevRequests();
    getClinic();
    getDistributors();
    getMedicine();
    getPharmacy();
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
    density = width * height;
    safePadding = MediaQuery.of(context).padding.top;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: 20,
            left: width / 5.8,
            right: width / 5.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10,
              ),
              child: GNav(
                mainAxisAlignment: MainAxisAlignment.center,
                haptic: true,
                rippleColor: col,
                hoverColor: col,
                gap: 8,
                activeColor: floatingButtonColor,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
                tabs: [
                  GButton(
                    icon: LineIcons.userShield,
                    text: 'Dashboard',
                    onPressed: () {},
                  ),
                  GButton(
                    icon: LineIcons.stethoscope,
                    text: 'Statistics',
                    onPressed: () {},
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                    if (index == 0) {
                      opac = 1;
                      opac2 = 0;
                    } else {
                      opac = 0;
                      opac2 = 1;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 246, 248),
        body: Container(
          height: height,
          width: width,
          child: IndexedStack(
            index: selectedIndex,
            children: <Widget>[
              AnimatedOpacity(
                opacity: opac,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: AdminDashboard(
                      width: width,
                      height: height,
                      count: count,
                      clinicCount: clinicCount,
                      distributorCount: distributorCount,
                      medCount: medCount,
                      pharmCount: pharmCount,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: opac2,
                duration: Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: AdminStatistics(
                      width: width,
                      height: height,
                      count: count,
                    ),
                  ),
                ),
              ),
            ],
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
class AdminDashboard extends StatefulWidget {
  final double width;
  final double height;
  final int count;
  final int distributorCount;
  final int pharmCount;
  final int clinicCount;
  final int medCount;

  AdminDashboard({
    Key key,
    @required this.width,
    @required this.height,
    this.count,
    this.distributorCount,
    this.pharmCount,
    this.clinicCount,
    this.medCount,
  }) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Color col = Color.fromARGB(255, 149, 191, 255);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (widget.width / 15),
          ),
          //
          //
          // The top title and the notification row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'DASHBOARD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.width / 17,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                width: widget.width / 7,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: widget.width / 9,
                      width: widget.width / 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ContactDevs(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.notifications_none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: widget.width / 18,
                      width: widget.width / 18,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distributors',
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
                          'Total Distributors:',
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
                              widget.distributorCount.toString(),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddDistributor(),
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
                                    'assets/icons/admin_dashboard_distributors/add.png',
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
                        //
                        //
                        // The second SEARCH MEDICINE Button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                  'assets/icons/admin_dashboard_distributors/view.png',
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Image(
                              width: widget.width / 4.9,
                              height: widget.width / 4.6,
                              image: AssetImage(
                                'assets/icons/admin_dashboard_distributors/search.png',
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: col,
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
          // The second PHARMACIES AND CLINICS container
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pharmacies and Clinics',
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
                          'Total Pharmacies:',
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
                              widget.pharmCount.toString(),
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
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Clinics:',
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
                              widget.clinicCount.toString(),
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
                        // The first VIEW CLINICS button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DistributorClinics(),
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
                                      'assets/icons/admin_pharmacies_clinics/viewClinics.png'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: col,
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        // The second VIEW PHARMACIES Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DistributorPharmacies(),
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
                                    'assets/icons/admin_pharmacies_clinics/viewPharmacies.png'),
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
            height: 30,
          ),
          //
          //
          // The third MEDICINE container
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                              widget.medCount.toString(),
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
                        // The first ABOUT button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ViewMedicine(
                                    pageName: 'View Medicine',
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
                                      'assets/icons/admin_dashboard_medicine/viewMedicine.png'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: col,
                              ),
                            ),
                          ),
                        ),
                        //
                        //
                        // The second TIPS Button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Image(
                                width: widget.width / 4.9,
                                height: widget.width / 4.6,
                                image: AssetImage(
                                    'assets/icons/admin_dashboard_medicine/searchMedicine.png'),
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
            height: 20,
          ),
        ],
      ),
    );
  }
}

//
//
// The STATISTICS PAGE
class AdminStatistics extends StatefulWidget {
  final double width;
  final double height;
  final int count;

  AdminStatistics({
    Key key,
    @required this.width,
    @required this.height,
    this.count,
  }) : super(key: key);

  @override
  _AdminStatisticsState createState() => _AdminStatisticsState();
}

class _AdminStatisticsState extends State<AdminStatistics> {
  Color col = Color.fromARGB(255, 149, 191, 255);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (widget.width / 15),
          ),
          //
          //
          // The top title and the notification icon
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'STATISTICS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.width / 17,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(
                width: widget.width / 7,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: widget.width / 9,
                      width: widget.width / 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ContactDevs(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(0),
                        child: Icon(
                          Icons.notifications_none,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: widget.width / 18,
                      width: widget.width / 18,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          //
          //
          // The first MEDICINE DISTRIBUTION AND GRAPHS
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Medicine Distribution',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.width / 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: widget.height < 800 ? 200 : widget.height / 4,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: widget.width / 2.5,
                            decoration: BoxDecoration(
                              color: col,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  bottom: 10,
                                  top: 15,
                                ),
                                child: BarChartWeekly()),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: widget.width / 2.5,
                            decoration: BoxDecoration(
                              color: col,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  bottom: 10,
                                  top: 15,
                                ),
                                child: BarChartWeekly()),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: widget.width / 2.5,
                            decoration: BoxDecoration(
                              color: col,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                  bottom: 10,
                                  top: 15,
                                ),
                                child: BarChartDaily()),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          //
          //
          // The second TOP DISTRIBUTORS
          Center(
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Distributors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget.width / 16,
                      ),
                    ),
                    SizedBox(
                      height: widget.height / 30,
                    ),
                    RowInfo(
                      width: widget.width,
                      title: 'Marhabba',
                      location: 'Laal Kurti District',
                      imageURL: 'https://picsum.photos/250?image=9',
                      func: null,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
