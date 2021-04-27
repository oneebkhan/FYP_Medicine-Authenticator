import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker_admin/screens/StartingPage.dart';

class ContactDevs extends StatefulWidget {
  @override
  _ContactDevsState createState() => _ContactDevsState();
}

class _ContactDevsState extends State<ContactDevs> {
  double width;
  double height;
  var devRequestsStream;

  //
  //
  // FUNCTION TO GET THE REQUESTS STREAM
  getDevRequests() async {
    try {
      setState(() {
        devRequestsStream = FirebaseFirestore.instance
            .collection('ContactDevelopers')
            .orderBy('nameOfUser')
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: '$e');
    }
  }

  //
  //
  // Sign out and go to starting page
  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(msg: 'Admin Signed Out');
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartingPage(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  delete(String val) async {
    try {
      await FirebaseFirestore.instance
          .collection("ContactDevelopers")
          .doc(val)
          .delete()
          .then((_) {
        Fluttertoast.showToast(msg: 'Delete Request Successful!');
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDevRequests();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width / 20,
                ),
                Text(
                  'Developer Requests',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width / 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: devRequestsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return snapshot.data.docs.length == 0
                          ? Container(
                              width: width,
                              height: height / 3,
                              child: Center(
                                child: Text('No Data found'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                QueryDocumentSnapshot item =
                                    snapshot.data.docs[index];

                                //
                                //
                                // the white container holding the request
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 15,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: width / 1.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Request #${item['number'].toString()}',
                                                      style: TextStyle(
                                                        fontSize: width / 18,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'Name: ${item['nameOfUser']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: width / 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Email: ${item['emailOfUser']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: width / 28,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Subject: ${item['subject']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: width / 28,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Description: ${item['description']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: width / 28,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //
                                              //
                                              // the close button
                                              IconButton(
                                                padding: EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.grey[700],
                                                ),
                                                onPressed: () {
                                                  delete('#' +
                                                      '${item['number']}' +
                                                      ' ' +
                                                      '(' +
                                                      '${item['emailOfUser']}' +
                                                      ')');
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: width / 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    }),
                //
                //
                // divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Divider(
                    thickness: 2,
                    color: Colors.red,
                  ),
                ),
                //
                //
                // logout button
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.red.withOpacity(0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: width / 18,
                      ),
                    ),
                  ),
                  onPressed: () {
                    signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
