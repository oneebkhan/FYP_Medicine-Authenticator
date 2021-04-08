import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/MedicineInfo.dart';
import 'package:tracker/screens/RequestMedicine.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  double opac;
  TextEditingController search = TextEditingController();
  var snapshotData;
  bool isSearched;
  bool isLoading;
  var snap;
  String hello = '';

  Future queryData(String queryString) async {
    setState(() {
      snap = FirebaseFirestore.instance.collection('Medicine').snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    isSearched = false;
    isLoading = false;
    snapshotData = null;
    search.addListener(() {
      setState(() {
        hello = search.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
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
                      'Search',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 14,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContainerText(
                          node: node,
                          hint: 'Medicine Name',
                          controller: search,
                          maxLines: 1,
                          width: width / 1.4,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: width / 7,
                            width: width / 7,
                            child: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                if (search.text == null || search.text == '') {
                                } else {
                                  setState(() {
                                    isLoading = true;
                                    isSearched = true;
                                  });
                                  queryData(search.text.toUpperCase())
                                      .whenComplete(() {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                            ),
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
                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: isSearched == false
                            ? Padding(
                                padding: EdgeInsets.only(top: width / 2),
                                child: Center(
                                  child: Container(
                                    child: Text(
                                      'Search for a Medicine\nFor the results to appear here',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: snap,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData == false) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.docs.length > 6
                                          ? 6
                                          : snapshot.data.docs
                                              .length, //snapshotData.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        QueryDocumentSnapshot item =
                                            snapshot.data.docs[index];
                                        if (item['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    hello.toLowerCase()) ||
                                            item['barcode']
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    hello.toLowerCase())) {
                                          return RowInfo(
                                            imageURL: item['imageURL'][0],
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
                                        } else {
                                          return Container();
                                        }
                                      });
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
