import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker/Widgets/InfoContainer.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/About.dart';
import 'package:tracker/screens/MedicineInfo.dart';

class ViewMedicine extends StatefulWidget {
  // The name of the category opened
  final String pageName;

  const ViewMedicine({
    Key key,
    @required this.pageName,
  }) : super(key: key);

  @override
  _ViewMedicineState createState() => _ViewMedicineState();
}

class _ViewMedicineState extends State<ViewMedicine> {
  double opac;
  var m;

  getMedicine() async {
    try {
      setState(() {
        m = FirebaseFirestore.instance
            .collection('Medicine')
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
    getMedicine();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var safePadding = MediaQuery.of(context).padding.top;

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
                  child: Container(
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
                        left: 20,
                        right: 20,
                        top: 20,
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
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                QueryDocumentSnapshot item =
                                    snapshot.data.docs[index];
                                return RowInfo(
                                  imageURL: item['imageURL'][0].toString(),
                                  location: item['dose'],
                                  width: width,
                                  title: item['name'],
                                  func: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MedicineInfo(
                                          medBarcode: item['barcode'],
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
