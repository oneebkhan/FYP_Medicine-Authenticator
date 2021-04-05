import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/Pharmacy_Clinics_Info.dart';

class ViewDistributors extends StatefulWidget {
  @override
  _ViewDistributorsState createState() => _ViewDistributorsState();
}

class _ViewDistributorsState extends State<ViewDistributors> {
  double opac;
  var pharmacyStream;

  //
  //
  // get distributors
  getDistributors() async {
    try {
      setState(() {
        pharmacyStream =
            FirebaseFirestore.instance.collection('Distributor').snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    getDistributors();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                'Distributors',
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
                            itemBuilder: (BuildContext context, int index) {
                              QueryDocumentSnapshot item =
                                  snapshot.data.docs[index];
                              return RowInfo(
                                imageURL: item['imageURL'] == null
                                    ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                    : item['imageURL'][0],
                                location: item['userEmail'],
                                width: width,
                                title: item['name'] + item['companyname'],
                                func: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Pharmacy_Clinics_Info(
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
