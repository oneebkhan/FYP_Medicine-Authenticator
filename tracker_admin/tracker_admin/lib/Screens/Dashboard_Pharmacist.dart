import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartMonthly.dart';
import 'package:tracker_admin/Widgets/Admin/BarChartWeekly.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartMonthly_Distributor.dart';
import 'package:tracker_admin/Widgets/Distributor/BarChartWeekly_Distributor.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/Clinics.dart';
import 'package:tracker_admin/screens/Pharmacies.dart';
import 'package:tracker_admin/screens/Requests.dart';
import 'package:tracker_admin/screens/ViewMedicine.dart';

class Dashboard_Pharmacist extends StatefulWidget {
  Dashboard_Pharmacist({Key key}) : super(key: key);

  @override
  _Dashboard_PharmacistState createState() => _Dashboard_PharmacistState();
}

class _Dashboard_PharmacistState extends State<Dashboard_Pharmacist> {
  double width;
  double height;
  double density;
  double safePadding;
  int index;
  Color col = Color.fromARGB(255, 148, 210, 146);
  Color floatingButtonColor = Color.fromARGB(255, 110, 200, 110);
  int selectedIndex;
  var page = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    index = 0;
    selectedIndex = 0;
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
                  });
                  if (index == 0) {
                    page.animateToPage(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else {
                    page.animateToPage(
                      1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 246, 246, 248),
        body: Container(
          height: height,
          width: width,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: page,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: AdminDashboard(
                    width: width,
                    height: height,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: AdminStatistics(
                    width: width,
                    height: height,
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

  AdminDashboard({Key key, @required this.width, @required this.height})
      : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Color col = Color.fromARGB(255, 148, 210, 146);

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
                              builder: (_) => Requests(),
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
                          '3',
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
                          'Number of Total Authenticated Medicines:',
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
                              '5',
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
                          'Number of Total Medicines:',
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
                              '5',
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
                            onTap: () {},
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Image(
                                  width: widget.width / 4.9,
                                  height: widget.width / 4.6,
                                  image: AssetImage(
                                    'assets/icons/Distributor_dashboard_medicine/addMedicine.png',
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewMedicine(
                                  pageName: 'View Medicine',
                                  imageUrls: [
                                    'https://picsum.photos/250?image=9',
                                    'https://picsum.photos/250?image=9',
                                    'https://picsum.photos/250?image=9',
                                  ],
                                  location: ['500mg', '400mg', '100mg'],
                                  title: [
                                    'Some Medicine',
                                    'ooga booga',
                                    'confused unga bunga',
                                  ],
                                  func: [
                                    null,
                                    null,
                                    null,
                                  ],
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
                                  'assets/icons/Distributor_dashboard_medicine/viewMedicine.png',
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
                                'assets/icons/Distributor_dashboard_medicine/searchMedicine.png',
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
                          'Number of Total Pharmacies:',
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
                              '5',
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
                          'Number of Total Clinics:',
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
                              '5',
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
                                  builder: (_) => Clinics(),
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
                                      'assets/icons/Distributor_dashboard_pharmacy/viewClinics.png'),
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
                        // The second ADD CLINICS Button
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
                                    'assets/icons/Distributor_dashboard_pharmacy/addClinic.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
                        //
                        //
                        // The third View Pharmacies
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Pharmacies(),
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
                                    'assets/icons/Distributor_dashboard_pharmacy/viewPharmacy.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: col,
                            ),
                          ),
                        ),
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
                                    'assets/icons/Distributor_dashboard_pharmacy/addPharmacy.png'),
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

  AdminStatistics({Key key, @required this.width, @required this.height})
      : super(key: key);

  @override
  _AdminStatisticsState createState() => _AdminStatisticsState();
}

class _AdminStatisticsState extends State<AdminStatistics> {
  Color col = Color.fromARGB(255, 148, 210, 146);

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
                              builder: (_) => Requests(),
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
                          '3',
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
                        'Medcine Distribution',
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
                                child: BarChartMonthly_Distributor()),
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
                                child: BarChartWeekly_Distributor()),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: widget.width / 23,
                                  ),
                                  Center(
                                    child: Container(
                                      height: widget.width / 4,
                                      width: widget.width / 4,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 189, 210, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '10',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 110, 200, 110).withOpacity(0.5),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            col,
                          ),
                        ),
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            'Generate Report',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
                      'Top Medicine',
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
                      title: 'Panadol',
                      imageURL:
                          'https://i-cf5.gskstatic.com/content/dam/cf-consumer-healthcare/panadol/en_ie/ireland-products/panadol-tablets/MGK5158-GSK-Panadol-Tablets-455x455.png?auto=format',
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
