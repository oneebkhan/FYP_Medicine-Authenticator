import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/Pharmacy_Clinics_Info.dart';

class ViewClinic extends StatefulWidget {
  // The name of the category opened
  final String pageName;
  final List clinics;

  const ViewClinic({
    Key key,
    @required @required this.pageName,
    @required this.clinics,
  }) : super(key: key);

  @override
  _ViewClinicState createState() => _ViewClinicState();
}

class _ViewClinicState extends State<ViewClinic> {
  double opac;
  var clinicStream;

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
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    getClinics();

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
                            itemBuilder: (BuildContext context, int index) {
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
                                      builder: (_) => Pharmacy_Clinics_Info(
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
