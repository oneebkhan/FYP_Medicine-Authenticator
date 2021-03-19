import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tracker/screens/RequestMedicine.dart';

// ignore: must_be_immutable
class ContactDevs extends StatefulWidget {
  @override
  _ContactDevsState createState() => _ContactDevsState();
}

class _ContactDevsState extends State<ContactDevs> {
  double width;
  double height;
  double safePadding;
  bool _isLoading = false;
  int docLen;
  TextEditingController nameOfUser = TextEditingController();
  TextEditingController emailOfUser = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();

  //
  //
  // Get length of documents to make a unique ID for the firestore doca
  // ignore: missing_return
  Future<double> _getLengthOfRequestsMedicine() async {
    await FirebaseFirestore.instance
        .collection("RequestsMedicine")
        .get()
        .then((doc) {
      setState(() {
        docLen = doc.docs.length;
      });
    });
  }

  //
  //
  // pressing the submit button will submit all the fields and update firestore
  Future<void> _onPressed() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore
          .collection("ContactDevelopers")
          .doc('#' + docLen.toString() + ' (${emailOfUser.text})')
          .set({
        "nameOfUser": nameOfUser.text,
        "emailOfUser": emailOfUser.text,
        "subject": subject.text,
        "description": description.text,
      }).then((_) {
        print("success!");
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    docLen = 0;
    _getLengthOfRequestsMedicine();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Developers',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ContainerText(
                                hint: 'User Name',
                                node: node,
                                controller: nameOfUser,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'User Email',
                                node: node,
                                controller: emailOfUser,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Subject',
                                node: node,
                                controller: subject,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Description',
                                node: node,
                                height: width / 2,
                                maxLines: 8,
                                controller: description,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        _onPressed();
                        setState(() {
                          _isLoading = true;
                        });
                        Future.delayed(Duration(milliseconds: 2000), () {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'Request Sent');
                        });
                      },
                      child: Container(
                        width: width / 1.1,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 149, 192, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
