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

// ignore: must_be_immutable
class EditPharmacy extends StatefulWidget {
  final String name;
  final String location;
  final String timings;
  final String ratings;
  final List imageURL;
  final String uid;

  EditPharmacy({
    this.imageURL,
    this.name,
    this.location,
    this.timings,
    this.ratings,
    this.uid,
  });

  @override
  _EditPharmacyState createState() => _EditPharmacyState();
}

class _EditPharmacyState extends State<EditPharmacy> {
  double width;
  double height;
  double safePadding;
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController timings = TextEditingController();
  TextEditingController ratings = TextEditingController();
  String currentDistributorEmail;
  bool _isLoading = false;
  bool con = true;
  var subscription;
  List imageURL;
  var img1;
  var img2;
  var img3;
  List<String> uploadedFileURL = [];
  int index;
  int index2;
  List deleteimages;
  List<bool> check = [false, false, false];
  List images;
  int check1 = 0;
  var info;

  //
  //
  //get Admin
  getDistributor() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        info = value.data();
      });
    });
  }

  //
  //
  // delete image from firebase
  deleteImage(f) async {
    for (int i = 0; i < widget.imageURL.length; i++) {
      if (check[i] == true) {
        String path = deleteimages[i];
        path = path.replaceAll(new RegExp(r'%2F'), '/');
        path = path.replaceAll(new RegExp(r'%40'), '@');
        path = path.replaceAll(new RegExp(r'(\?alt).*'), '');

        //print('${path.split('appspot.com/o/')[1]}');
        try {
          return await FirebaseStorage.instance
              .ref()
              .child('${path.split('appspot.com/o/')[1]}')
              .delete();
        } catch (e) {
          print(e);
          break;
        }
      }
    }

    uploadFile(f);
  }

  //
  //
  // The function to pick the images from the gallery
  chooseGalleryImage(i) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile.path == null) {
      retrieveLostData(i);
    } else if (pickedFile != null) {
      setState(() {
        if (i == 0) {
          img1 = File(pickedFile?.path);
        } else if (i == 1) {
          img2 = File(pickedFile?.path);
        } else {
          img3 = File(pickedFile?.path);
        }

        check[i] = true;
      });
    }
  }

  //
  //
  // The function to pick the images from the camera
  chooseCameraImage(i) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile.path == null) {
      retrieveLostData(i);
    } else if (pickedFile != null) {
      setState(() {
        if (i == 0) {
          img1 = File(pickedFile?.path);
        } else if (i == 1) {
          img2 = File(pickedFile?.path);
        } else {
          img3 = File(pickedFile?.path);
        }

        check[i] = true;
      });
    }
  }

  //
  //
  // The function for error correction
  Future<void> retrieveLostData(i) async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return Fluttertoast.showToast(msg: 'No file picked');
    }
    if (response.file != null) {
      setState(() {
        if (i == 0) {
          img1 = File(response.file.path);
        } else if (i == 1) {
          img2 = File(response.file.path);
        } else {
          img3 = File(response.file.path);
        }
        check[i] = true;
      });
    } else {
      print(response.file);
      Fluttertoast.showToast(msg: 'No file picked');
    }
  }

  //
  //
  // Upload the images to firestore
  Future uploadFile(f) async {
    setState(() {
      images = [img1, img2, img3];
    });
    FirebaseStorage _storage = FirebaseStorage.instance;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _isLoading = true;
      });
      try {
        //saving the image to the cloud
        for (index2 = 0; index2 < 3; index2++) {
          if (check[index2] == true) {
            var snapshot = await _storage
                .ref('Pharmacies/${name.text}/image$index2.png')
                .putFile(images[index2]);
            //getting the image url
            var downloadURL = await snapshot.ref.getDownloadURL();
            setState(() {
              uploadedFileURL[index2] = downloadURL;
            });
          }
        }
        editPharmacyInfo(f);
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
  editPharmacyInfo(f) async {
    List filesToBeUploaded = f;
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("Pharmacy").doc(widget.uid).update({
        "imageURL": uploadedFileURL,
        "rating": ratings.text,
        "timings": timings.text,
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
          "name": name.text + ' pharmacy was edited',
          "category": 'distributor',
        });
        Fluttertoast.showToast(msg: 'Pharmacy edited Succesfully!');
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
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
    getDistributor();
    uploadedFileURL = widget.imageURL;
    name.text = widget.name;
    location.text = widget.location;
    ratings.text = widget.ratings;
    timings.text = widget.timings;
    deleteimages = widget.imageURL;
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
                                'Edit Pharmacy',
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
                                  'Pharmacy Name:',
                                  style: TextStyle(
                                    fontSize: width / 25,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              ContainerText(
                                enabled: false,
                                node: node,
                                hint: widget.name,
                                controller: name,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  //image 1
                                  ////////////////////////////////
                                  img1 == null
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
                                                        chooseCameraImage(0);
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          check1 = 1;
                                                        });
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        setState(() {
                                                          check1 = 1;
                                                        });
                                                        chooseGalleryImage(0);
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
                                                      // the old image
                                                      widget.imageURL.length ==
                                                              0
                                                          ? 'https://cdn.iconscout.com/icon/free/png-512/data-not-found-1965034-1662569.png'
                                                          : widget.imageURL[0],
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
                                                        chooseCameraImage(0);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage(0);
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
                                                    img1,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  /////////////////////////////////////////
                                  //
                                  //
                                  /////image 2
                                  ////////////////////////////////
                                  img2 == null
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
                                                        chooseCameraImage(1);
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          check1 = 1;
                                                        });
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        setState(() {
                                                          check1 = 1;
                                                        });
                                                        chooseGalleryImage(1);
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
                                                      // the old image
                                                      widget.imageURL.length ==
                                                                  1 ||
                                                              widget.imageURL
                                                                      .length ==
                                                                  0
                                                          ? 'https://cdn.iconscout.com/icon/free/png-512/data-not-found-1965034-1662569.png'
                                                          : widget.imageURL[1],
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
                                                        chooseCameraImage(1);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage(1);
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
                                                    img2,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  /////////////////////////////////////////
                                  //
                                  //
                                  /////image 3
                                  ////////////////////////////////
                                  img3 == null
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
                                                        chooseCameraImage(2);
                                                        Navigator.pop(context);

                                                        setState(() {
                                                          check1 = 1;
                                                        });
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage(2);
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          check1 = 1;
                                                        });
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
                                                      // the old image
                                                      widget.imageURL.length ==
                                                                  2 ||
                                                              widget.imageURL
                                                                      .length ==
                                                                  1 ||
                                                              widget.imageURL
                                                                      .length ==
                                                                  0
                                                          ? 'https://cdn.iconscout.com/icon/free/png-512/data-not-found-1965034-1662569.png'
                                                          : widget.imageURL[2],
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
                                                        chooseCameraImage(2);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Gallery'),
                                                      onPressed: () {
                                                        chooseGalleryImage(2);
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
                                                    img3,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  /////////////////////////////////////////
                                ],
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
                                controller: location,
                                node: node,
                                enabled: false,
                                maxLength: 200,
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Text(
                                            'Rating:',
                                            style: TextStyle(
                                              fontSize: width / 25,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        ContainerText(
                                          hint: 'Rating',
                                          controller: ratings,
                                          node: node,
                                          maxLength: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 20,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Text(
                                            'Timings:',
                                            style: TextStyle(
                                              fontSize: width / 25,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        ContainerText(
                                          hint: 'Timings',
                                          node: node,
                                          controller: timings,
                                          maxLength: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                            ratings.text.isEmpty ||
                            timings.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          if (check1 == 1 && widget.imageURL != []) {
                            deleteImage(uploadedFileURL);
                          } else if (widget.imageURL == []) {
                            uploadFile(uploadedFileURL);
                          } else
                            editPharmacyInfo(deleteimages);
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
