import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracker_admin/screens/admin_screens/AddDistributor.dart';

// ignore: must_be_immutable
class EditDistributor extends StatefulWidget {
  final String name;
  final String email;
  final String companyName;
  final String location;
  final String phoneNumber;
  final String image;

  EditDistributor({
    this.name,
    this.email,
    this.companyName,
    this.location,
    this.phoneNumber,
    this.image,
  });

  @override
  _EditDistributorState createState() => _EditDistributorState();
}

class _EditDistributorState extends State<EditDistributor> {
  double width;
  double height;
  double safePadding;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String currentDistributorEmail;
  bool _isLoading = false;
  bool con = true;
  var subscription;
  String imageURL;
  File image;
  String uploadedFileURL;
  String adminEmail;

  //
  //
  // delete image from firebase
  deleteImage() async {
    String path = widget.image;
    path = path.replaceAll(new RegExp(r'%2F'), '/');
    path = path.replaceAll(new RegExp(r'%40'), '@');
    path = path.replaceAll(new RegExp(r'(\?alt).*'), '');

    //print('${path.split('appspot.com/o/')[1]}');

    return await FirebaseStorage.instance
        .ref()
        .child('${path.split('appspot.com/o/')[1]}')
        .delete()
        .then((value) => uploadFile());
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
        image = File(pickedFile?.path);
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
        image = File(pickedFile?.path);
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
        image = File(response.file.path);
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
        var snapshot = await _storage
            .ref(
                'Distributors/${email.text}/${Timestamp.now().millisecondsSinceEpoch}.png')
            .putFile(image);
        //getting the image url
        var downloadURL = await snapshot.ref.getDownloadURL();
        setState(() {
          uploadedFileURL = downloadURL;
        });
        editDistributorInfo();
        //addEventFirebase();
        //navigate();
        // updates the user image url field
      } on FirebaseException catch (e) {
        print(e.code);
      }
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
  editDistributorInfo() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("Distributor").doc(email.text).update({
        "name": name.text,
        "companyName": companyName.text,
        "location": location.text,
        "addedByAdmin": currentDistributorEmail,
        "phoneNumber": phoneNumber.text,
        "image": uploadedFileURL,
        "EditedBy": {adminEmail: Timestamp.now()},
      }).then((_) {
        Fluttertoast.showToast(msg: 'Distributor created Succesfully!');
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

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    email.text = widget.email;
    companyName.text = widget.companyName;
    location.text = widget.location;
    phoneNumber.text = widget.phoneNumber;
    adminEmail = FirebaseAuth.instance.currentUser.email;
    checkInternet();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      checkInternet();
    });
    // this stores the current distributor email
    currentDistributorEmail = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    final node = FocusScope.of(context);
    var medName = TextEditingController();

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
                                'Edit Distributor',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  'Email:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ContainerText(
                                enabled: false,
                                hint: 'User Email',
                                node: node,
                                controller: email,
                                inputType: TextInputType.emailAddress,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  'Name:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  image == null
                                      ? Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            customBorder: CircleBorder(),
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title:
                                                      Text('Camera or Gallery'),
                                                  content: Text(
                                                      'Choose either the camera or the gallery to get the image'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Camera'),
                                                      onPressed: () {
                                                        chooseCameraImage();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                              //chooseImage();
                                            },
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      // the 4th image URL
                                                      widget.image,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: width / 8,
                                                    height: width / 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                                Container(
                                                  width: width / 7.5,
                                                  height: width / 7.8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black26,
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title:
                                                      Text('Camera or Gallery'),
                                                  content: Text(
                                                      'Choose either the camera or the gallery to get the image'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Camera'),
                                                      onPressed: () {
                                                        chooseCameraImage();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            customBorder: CircleBorder(),
                                            child: Container(
                                              width: width / 8,
                                              height: width / 8,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    image,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                  Expanded(
                                    child: ContainerText(
                                      hint: 'User Name',
                                      node: node,
                                      controller: name,
                                      maxLength: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  'Phone Number:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ContainerText(
                                hint: 'Phone Number',
                                node: node,
                                controller: phoneNumber,
                                inputType: TextInputType.phone,
                                maxLength: 15,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  'Company Name:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ContainerText(
                                hint: 'Company Name',
                                node: node,
                                controller: companyName,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  'Location:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ContainerText(
                                hint: 'Location',
                                node: node,
                                controller: location,
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
                        } else if (name.text.isEmpty ||
                            email.text.isEmpty ||
                            phoneNumber.text.isEmpty ||
                            companyName.text.isEmpty ||
                            location.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else {
                          if (image != null && widget.image != '') {
                            deleteImage();
                          } else if (widget.image == '') {
                            uploadFile();
                          } else
                            editDistributorInfo();
                        }
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
