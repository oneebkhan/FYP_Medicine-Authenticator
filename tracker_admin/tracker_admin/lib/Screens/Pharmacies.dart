import 'package:flutter/material.dart';
import 'package:tracker_admin/Widgets/InfoContainer.dart';
import 'package:tracker_admin/screens/ViewPharmacyOrClinic.dart';

class Pharmacies extends StatefulWidget {
  @override
  _PharmaciesState createState() => _PharmaciesState();
}

class _PharmaciesState extends State<Pharmacies> {
  var width;
  var height;
  var safePadding;

  double opac;
  @override
  void initState() {
    super.initState();
    opac = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width / 20,
                ),
                Text(
                  'Pharmacies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 14,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //
                //
                // The container fields
                AnimatedOpacity(
                  opacity: opac,
                  duration: Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      InfoContainer(
                        color: Colors.green,
                        description: '5 Pharmacies',
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPharmacyOrClinic(
                                pageName: 'Hajji Ltd.',
                              ),
                            ),
                          );
                        },
                        imageUrls: [
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                        ],
                        title: 'Hajji Ltd.',
                        width: width,
                      ),
                      InfoContainer(
                        color: Colors.purple,
                        description: '5 Pharmacies',
                        func: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPharmacyOrClinic(
                                pageName: 'Floyd\'s Pharmacy',
                              ),
                            ),
                          );
                        },
                        imageUrls: [
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                          'https://picsum.photos/250?image=9',
                        ],
                        title: 'Floyd\'s Pharmacy',
                        width: width,
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
