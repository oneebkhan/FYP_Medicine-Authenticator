import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tracker_admin/screens/About.dart';
import 'package:tracker_admin/screens/Clinics.dart';
import 'package:tracker_admin/screens/Pharmacies.dart';
import 'package:tracker_admin/screens/Tips.dart';
import 'package:tracker_admin/screens/ViewMedicine.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

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

  List<String> title = ['DASHBOARD', 'STATISTICS'];
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    index = 0;
    selectedIndex = 0;
    floatingButtonColor = Color.fromARGB(255, 130, 150, 250);
  }

//
//
// the function to scan the barcode

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    density = width * height;
    safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBody: true,
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
                ),
                GButton(
                  icon: LineIcons.stethoscope,
                  text: 'Statistics',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (width / 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${title[index]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 17,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: width / 7,
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: width / 9,
                            width: width / 9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FlatButton(
                              onPressed: () {},
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
                            height: width / 18,
                            width: width / 18,
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
                // The first MEDICINE container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distributors',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of Total Distributors:',
                                style: TextStyle(
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                'Number of Total Distributors:',
                                style: TextStyle(
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                        width: width / 4.9,
                                        height: width / 4.6,
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
                                      width: width / 4.9,
                                      height: width / 4.6,
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
                              //
                              //
                              // The third VIEW MEDICINE BUTTON
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (_) => ViewMedicine(
                              //           func: [
                              //             null,
                              //             null,
                              //             null,
                              //           ],
                              //           imageUrls: [
                              //             'https://picsum.photos/250?image=9',
                              //             'https://picsum.photos/250?image=9',
                              //             'https://picsum.photos/250?image=9',
                              //           ],
                              //           location: [
                              //             '500mg',
                              //             null,
                              //             null,
                              //           ],
                              //           pageName: 'Medicines',
                              //           title: [
                              //             'Panadol',
                              //             'Paracetamol',
                              //             'Cake',
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              /*child:*/ Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Image(
                                    width: width / 4.9,
                                    height: width / 4.6,
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
                              //),
                              //
                              //
                              // The fourth SCAN FROM GALLERY BARCODE button
                            ],
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
                // The second PHARMACIES AND CLINICS container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pharmacies and Clinics',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
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
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                        width: width / 4.9,
                                        height: width / 4.6,
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
                                      builder: (_) => Pharmacies(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Image(
                                      width: width / 4.9,
                                      height: width / 4.6,
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
                // The third EXTRAS container
                Center(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width / 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of Authenticated Medicines:',
                                style: TextStyle(
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                  fontSize: width / 30,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: width / 15,
                                height: width / 20,
                                decoration: BoxDecoration(
                                  color: col,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width / 30,
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
                                  onTap: () {},
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Image(
                                        width: width / 4.9,
                                        height: width / 4.6,
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
                                      width: width / 4.9,
                                      height: width / 4.6,
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
          ),
        ),
      ),
    );
  }
}
