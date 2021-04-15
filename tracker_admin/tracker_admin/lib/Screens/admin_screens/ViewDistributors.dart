import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/screens/admin_screens/Distributor.dart';

class ViewDistributors extends StatefulWidget {
  @override
  _ViewDistributorsState createState() => _ViewDistributorsState();
}

class _ViewDistributorsState extends State<ViewDistributors> {
  double opac;
  var distributorStream;
  List<bool> selection;

  //
  //
  // get distributors
  getDistributors() async {
    try {
      setState(() {
        distributorStream = FirebaseFirestore.instance
            .collection('Distributor')
            .orderBy('name', descending: false)
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
    getDistributors();
    selection = [false, true];
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Distributors',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width / 14,
                    ),
                  ),
                  SizedBox(
                    width: width / 6,
                  ),
                  Text(
                    'Sort: ',
                    style: TextStyle(
                      fontSize: width / 30,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ToggleButtons(
                      fillColor: Colors.white,
                      highlightColor: Color.fromARGB(255, 170, 200, 240),
                      splashColor: Color.fromARGB(255, 170, 200, 240),
                      borderRadius: BorderRadius.circular(10),
                      focusColor: Colors.white,
                      selectedColor: Color.fromARGB(255, 170, 200, 240),
                      onPressed: (int index) {
                        if (index == 0) {
                          setState(() {
                            selection[0] = true;
                            selection[1] = false;
                            distributorStream = FirebaseFirestore.instance
                                .collection('Distributor')
                                .orderBy('companyName', descending: false)
                                .snapshots();
                          });
                          Fluttertoast.showToast(msg: 'Sorted by Company Name');
                        } else if (index == 1) {
                          setState(() {
                            selection[1] = true;
                            selection[0] = false;
                            distributorStream = FirebaseFirestore.instance
                                .collection('Distributor')
                                .orderBy('name', descending: false)
                                .snapshots();
                          });
                          Fluttertoast.showToast(
                              msg: 'Sorted by Distributor Name');
                        }
                      },
                      constraints: BoxConstraints(
                        minHeight: width / 11,
                        minWidth: width / 10,
                      ),
                      children: [
                        Icon(
                          Icons.account_balance_rounded,
                          size: width / 20,
                        ),
                        Icon(
                          Icons.person,
                          size: width / 20,
                        ),
                      ],
                      isSelected: selection,
                    ),
                  ),
                ],
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
                      top: 10,
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: distributorStream,
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
                                imageURL: item['image'] == ''
                                    ? 'https://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                    : item['image'],
                                location: item['email'],
                                width: width,
                                title:
                                    item['name'] + ' - ' + item['companyName'],
                                func: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Distributor(
                                        dist: item['email'].toString(),
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
