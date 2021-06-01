import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/Pharmacy_Clinics_Info.dart';
import 'package:tracker_admin/screens/distributor_screens/Pharmacy_Clinics_Info_Distributor.dart';

class ViewClinic_Distributor extends StatefulWidget {
  // The name of the category opened
  final String pageName;
  final List clinics;

  const ViewClinic_Distributor({
    Key key,
    @required @required this.pageName,
    @required this.clinics,
  }) : super(key: key);

  @override
  _ViewClinic_DistributorState createState() => _ViewClinic_DistributorState();
}

class _ViewClinic_DistributorState extends State<ViewClinic_Distributor> {
  double opac;
  var clinicStream;
  bool con;
  double height;
  double width;

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
  getClinics() async {
    try {
      setState(() {
        clinicStream = FirebaseFirestore.instance
            .collection('Clinic')
            .where('uid', whereIn: widget.clinics)
            .snapshots();
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
    getClinics();
    checkInternet();

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
                              stream: clinicStream,
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
                                    return new RowInfo(
                                      imageURL: item['imageURL'][0],
                                      location: item['location'],
                                      width: width,
                                      title: item['name'],
                                      func: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                Pharmacy_Clinics_Info_Distributor(
                                              name: item['uid'],
                                              pharmOrClinic: 'Clinic',
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
