import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';
import 'package:geocoder/geocoder.dart';

// ignore: must_be_immutable
class AddPharmacy extends StatefulWidget {
  @override
  _AddPharmacyState createState() => _AddPharmacyState();
}

class _AddPharmacyState extends State<AddPharmacy> {
  double width;
  double height;
  double safePadding;
  TextEditingController pharmName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController timings = TextEditingController();
  TextEditingController activeIngredients = TextEditingController();
  TextEditingController otherIngredients = TextEditingController();
  TextEditingController sideEffects = TextEditingController();
  TextEditingController uses = TextEditingController();
  TextEditingController compName = TextEditingController();
  String currentDistributorEmail;
  bool _isLoading = false;
  bool con = true;
  var subscription;
  String imageURL;
  List<File> image = [];
  List<String> uploadedFileURL = [];
  String adminEmail;
  int index;
  int index2;
  var info;
  List distributorPharmacies = [];
  GeoPoint latLong;

  //
  //
  // save latitude and longitude for nearest pharmacy and clinics
  convertLatLong() async {
    try {
      var addresses =
          await Geocoder.local.findAddressesFromQuery(location.text);
      var first = addresses.first;
      setState(() {
        latLong =
            GeoPoint(first.coordinates.latitude, first.coordinates.longitude);
      });
      print(first.coordinates);
      uploadFile();
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Invalid Address');
    }
  }

  //
  //
  //get Distributor
  getDistributor() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        info = value.data();
        distributorPharmacies = info['pharmacyAdded'];
      });
    });
  }

  //
  //
  // The function to pick the images from the gallery
  chooseGalleryImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile.path == null) {
      retrieveLostData();
    } else if (pickedFile != null) {
      setState(() {
        image.add(File(pickedFile?.path));
      });
    }
  }

  //
  //
  // The function to pick the images from the camera
  chooseCameraImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile.path == null) {
      retrieveLostData();
    } else if (pickedFile != null) {
      setState(() {
        image.add(File(pickedFile?.path));
      });
    }
  }

  //
  //
  // The function for error correction
  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return Fluttertoast.showToast(msg: 'No file picked');
    }
    if (response.file != null) {
      setState(() {
        image.add(File(response.file.path));
      });
    } else {
      print(response.file);
      Fluttertoast.showToast(msg: 'No file picked');
    }
  }

  //
  //
  // Upload the images to firestore
  Future uploadFile() async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _isLoading = true;
      });
      try {
        //saving the image to the cloud
        for (index2 = 0; index2 < image.length; index2++) {
          var snapshot = await _storage
              .ref('Pharmacies/${pharmName.text}/image$index2.png')
              .putFile(image[index2]);
          //getting the image url
          var downloadURL = await snapshot.ref.getDownloadURL();
          setState(() {
            uploadedFileURL.insert(index2, downloadURL);
          });
        }
        addPharmacyInfo();
        //
        //
        // updates the user image url field
      } on FirebaseException catch (e) {
        print(e.code);
      }
      // erorrs
    } else {
      Fluttertoast.showToast(
        msg: 'Error Uploading image.\nPermission denied',
      );
    }
  }

  //
  //
  //check  the internet connectivity
  checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult.toString());
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
  // this function adds distributor information to Firebase Firestore
  addPharmacyInfo() async {
    try {
      convertLatLong();
      setState(() {
        distributorPharmacies
            .add(pharmName.text + location.text.substring(0, 10));
      });
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore
          .collection("Pharmacy")
          .doc(pharmName.text + location.text.substring(0, 10))
          .set({
        "name": pharmName.text,
        "location": location.text,
        "companyName": info['companyName'],
        "employees": [],
        "phoneNumber": phoneNumber.text,
        "rating": rating.text,
        "timings": timings.text,
        "uid": pharmName.text + location.text.substring(0, 10),
        "addedBy": info['email'],
        "imageURL": uploadedFileURL,
        "latLong": latLong,
        "availableMedicine": [],
        "lastEditedBy": {
          FirebaseAuth.instance.currentUser.email: Timestamp.now()
        },
      }).then((_) async {
        var fire = await FirebaseFirestore.instance;
        fire.collection("History").doc(DateTime.now().toString()).set({
          "timestamp": DateTime.now(),
          "by": info['email'],
          "byCompany": info['companyName'],
          "image": info['image'],
          "name": 'Addition of ' + pharmName.text + ' as a Pharmacy',
          "category": 'distributor',
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("Distributor")
              .doc(FirebaseAuth.instance.currentUser.email)
              .update({
            "pharmacyAdded": distributorPharmacies,
          });
        });
        Fluttertoast.showToast(msg: 'Pharmacy created Succesfully!');
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  checkForPharmacy() async {
    var fire = await FirebaseFirestore.instance
        .collection('Pharmacy')
        .doc(pharmName.text)
        .get()
        .then((value) {
      if (value.data().toString() == 'null') {
        convertLatLong();
        return null;
      } else {
        Fluttertoast.showToast(msg: 'Pharmacy already present!');
        return null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDistributor();
    List<File> _image = [];
    List<String> _uploadedFileURL = [];
    index2 = 0;
    index = 0;

    adminEmail = FirebaseAuth.instance.currentUser.email;
    checkInternet();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
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
              child: Column(
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
                                'Add Pharmacy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //
                              //
                              // images stored here
                              Container(
                                width: width,
                                height: width / 8,
                                child: GridView.builder(

                                    // make sure the grid takes the minimum space
                                    shrinkWrap: true,
                                    //disable scrolling in the gridview
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: image.length + 1,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 1,
                                            crossAxisSpacing: 5,
                                            crossAxisCount: 6),
                                    itemBuilder: (context, index) {
                                      return index == 0
                                          ? image.length >= 3
                                              ? //
                                              //
                                              // The container shown when 5 images are added
                                              Container(
                                                  width: width / 8,
                                                  height: width / 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.horizontal_rule,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'A maximum of 3 images can be selected');
                                                    },
                                                  ),
                                                )

                                              ///
                                              ///
                                              /// The add pictures container
                                              : Container(
                                                  width: width / 8,
                                                  height: width / 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Camera or Gallery'),
                                                          content: Text(
                                                              'Choose either the camera or the gallery to get the image'),
                                                          actions: [
                                                            TextButton(
                                                              child: Text(
                                                                  'Camera'),
                                                              onPressed: () {
                                                                chooseCameraImage();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Gallery'),
                                                              onPressed: () {
                                                                chooseGalleryImage();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )

                                          ///
                                          ///
                                          /// The images
                                          : Stack(
                                              children: [
                                                Container(
                                                  width: width / 8,
                                                  height: width / 8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        image[index - 1],
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: width / 8,
                                                  height: width / 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        image.removeAt(
                                                            index - 1);
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                    }),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //
                              //
                              // The images selected text
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${image.length}/3 images selected',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                30,
                                        color: image.length < 1
                                            ? Colors.grey
                                            : Colors.grey[800]),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ContainerText(
                                hint: 'Pharmacy Name',
                                node: node,
                                controller: pharmName,
                                maxLength: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                  hint: 'Address',
                                  controller: location,
                                  node: node,
                                  maxLength: 300,
                                  maxLines: 8,
                                  height: width / 3),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Phone Number',
                                controller: phoneNumber,
                                inputType: TextInputType.phone,
                                node: node,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Rating',
                                node: node,
                                controller: rating,
                                maxLength: 1,
                                inputType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Timings',
                                node: node,
                                controller: timings,
                                maxLength: 30,
                              ),

                              SizedBox(
                                height: 20,
                              )
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
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        if (con == true) {
                          Fluttertoast.showToast(
                              msg: 'No internet connection!');
                        } else if (pharmName.text.isEmpty ||
                            location.text.isEmpty ||
                            phoneNumber.text.isEmpty ||
                            rating.text.isEmpty ||
                            timings.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else if (image.length < 3) {
                          Fluttertoast.showToast(msg: 'Select 3 images');
                        } else {
                          checkForPharmacy();
                        }
                      },
                      child: Container(
                        width: width / 1.1,
                        height: width / 8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 148, 210, 146),
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
