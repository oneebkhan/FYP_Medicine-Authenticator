import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/admin_screens/MedicineModelInfo.dart';

class ViewMedicineModel extends StatefulWidget {
  // The name of the category opened
  final String pageName;

  const ViewMedicineModel({
    Key key,
    @required this.pageName,
  }) : super(key: key);

  @override
  _ViewMedicineModelState createState() => _ViewMedicineModelState();
}

class _ViewMedicineModelState extends State<ViewMedicineModel> {
  double opac;
  var m;
  double height;
  double width;
  double safePadding;
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
  //get mediicne info
  getMedicine() async {
    try {
      setState(() {
        m = FirebaseFirestore.instance
            .collection('MedicineModel')
            .orderBy('name')
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
    getMedicine();

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
      extendBodyBehindAppBar: true,
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
                  height: (width / 15),
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
                                padding: EdgeInsets.only(
                                    top: height / 3, bottom: 20),
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
                                stream: m,
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      QueryDocumentSnapshot item =
                                          snapshot.data.docs[index];
                                      return RowInfo(
                                        imageURL:
                                            item['imageURL'][0].toString(),
                                        location: item['dose'],
                                        width: width,
                                        title: item['name'],
                                        func: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MedicineModelInfo(
                                                name: item['name'],
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
      ),
    );
  }
}
