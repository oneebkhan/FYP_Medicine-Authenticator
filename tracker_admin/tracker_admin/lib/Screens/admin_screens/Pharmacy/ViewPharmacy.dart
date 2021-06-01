import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/Pharmacy_Clinics_Info.dart';

class ViewPharmacy extends StatefulWidget {
  // The name of the category opened
  final String pageName;
  final List pharmacies;

  const ViewPharmacy({
    Key key,
    @required @required this.pageName,
    @required this.pharmacies,
  }) : super(key: key);

  @override
  _ViewPharmacyState createState() => _ViewPharmacyState();
}

class _ViewPharmacyState extends State<ViewPharmacy> {
  double opac;
  double height;
  double width;
  var pharmacyStream;
  bool con;

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

  //
  //
  // get pharmacies
  getDistributors() async {
    try {
      setState(() {
        pharmacyStream = FirebaseFirestore.instance
            .collection('Pharmacy')
            .where('uid', whereIn: widget.pharmacies)
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    checkInternet();
    getDistributors();

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 246, 246, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[700],
        ),
      ),
      body: SafeArea(
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
                widget.pageName,
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
                child: con == true
                    ? Center(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: height / 3, bottom: 20),
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
                    : Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: pharmacyStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData == false) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    QueryDocumentSnapshot item =
                                        snapshot.data.docs[index];
                                    return RowInfo(
                                      imageURL: item['imageURL'][0],
                                      location: item['location'],
                                      width: width,
                                      title: item['name'],
                                      func: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                Pharmacy_Clinics_Info(
                                              name: item['uid'],
                                              pharmOrClinic: 'Pharmacy',
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }),
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
