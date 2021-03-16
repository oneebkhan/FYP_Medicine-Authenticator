import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker/Widgets/InfoContainer.dart';
import 'package:tracker/screens/Pharmacy/ViewPharmacy.dart';

class DistributorPharmacies extends StatefulWidget {
  @override
  _DistributorPharmaciesState createState() => _DistributorPharmaciesState();
}

class _DistributorPharmaciesState extends State<DistributorPharmacies> {
  var width;
  var height;
  var safePadding;
  double opac;
  List<Widget> numberOfImagesIndex;
  List<String> pharm;
  // Variable that stores the distributors
  var distributor;
  // variable that stores the pharmacies that the distributor added
  var pharmacies;
  var temp;

  //
  //
  // The function to get distributors
  getDistributors() async {
    try {
      setState(() {
        distributor = FirebaseFirestore.instance
            .collection('Distributor')
            .orderBy('name')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //
  //
  // The function to get distributors
  getPharmacies() async {
    try {
      setState(() {
        temp = FirebaseFirestore.instance
            .collection('Pharmacies')
            .orderBy('name')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  //
  //
  //
  getList() async {
    DocumentSnapshot cake = await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(distributor['email'].toString())
        .get();

    setState(() {
      pharm = cake['pharmacyAdded'];
    });
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    numberOfImagesIndex = [];
    pharm = [];
    getDistributors();
    getPharmacies();
    getList();

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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: distributor,
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
                            return InfoContainer(
                              color: Colors.green,
                              description:
                                  '${item['pharmacyAdded'].length} Pharmacies',
                              func: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ViewPharmacy(
                                      pageName: item['name'],
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
                              title: item['name'],
                              width: width,
                              height: height,
                              countOfImages: item['pharmacyAdded'].length,
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
