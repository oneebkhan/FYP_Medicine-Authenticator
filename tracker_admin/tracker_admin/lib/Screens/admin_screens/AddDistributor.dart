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

// ignore: must_be_immutable
class AddDistributor extends StatefulWidget {
  @override
  _AddDistributorState createState() => _AddDistributorState();
}

class _AddDistributorState extends State<AddDistributor> {
  double width;
  double height;
  double safePadding;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
  String by;
  String byCompany;
  String imageAdmin;

  //
  //
  // get admin
  getAdmin() async {
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        by = value.data()['email'];
        byCompany = value.data()['companyName'];
        imageAdmin = value.data()['image'];
      });
    });
  }

  //
  //
  // check distributor
  checkDistributor() async {
    await FirebaseFirestore.instance
        .collection('Distributor')
        .doc(email.text.toLowerCase())
        .get()
        .then((value) {
      if (value.data() == null) {
        uploadFile();
        return null;
      } else {
        Fluttertoast.showToast(msg: 'Distributor already exists!');
        return null;
      }
    });
  }

  //
  //
  //update History
  updateHistory() {
    var fire = FirebaseFirestore.instance;
    fire.collection('History').doc(DateTime.now().toString()).set({
      "timestamp": DateTime.now(),
      "by": by,
      "byCompany": byCompany,
      "image": imageAdmin,
      "name": name.text + ' added as a distributor',
      "category": 'admin',
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
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
        registerDistributor();

        //addEventFirebase();
        //navigate();

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
  // this functions adds a distributor to Firebase Auth
  registerDistributor() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      addDistributorInfo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e);
      setState(() {
        _isLoading = false;
      });
    }
    await app.delete();
  }

  //
  //
  // this function adds distributor information to Firebase Firestore
  addDistributorInfo() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("Distributor").doc(email.text.toLowerCase()).set({
        "name": name.text,
        "email": email.text.toLowerCase(),
        "password": password.text,
        "companyName": companyName.text,
        "location": location.text,
        "addedBy": currentDistributorEmail,
        "phoneNumber": phoneNumber.text,
        "dateAdded": Timestamp.now(),
        "clinicImages": [],
        "clinicsAdded": [],
        "pharmacyAdded": [],
        "pharmacyImages": [],
        "image": uploadedFileURL,
        "EditedBy": {adminEmail.toString(): Timestamp.now()},
      }).then((_) {
        Fluttertoast.showToast(msg: 'Distributor created Succesfully!');
        updateHistory();
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: '$e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  //
  //
  // Validate the Email Address
  String validateEmail(String value) {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: 'Enter Email');
      return "enter email";
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      Fluttertoast.showToast(msg: 'Invalid Email Address');
      return "the email address is not valid";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // name;
    // email;
    // password;
    // companyName;
    // location;
    // phoneNumber;
    checkInternet();
    getAdmin();
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
                                'Add Distributor',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
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
                                                      'https://www.spicefactors.com/wp-content/uploads/default-user-image.png',
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
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.grey,
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
                              ContainerText(
                                hint: 'User Email',
                                node: node,
                                controller: email,
                                inputType: TextInputType.emailAddress,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Password',
                                node: node,
                                controller: password,
                                hide: true,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
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
                              ContainerText(
                                hint: 'Company Name',
                                node: node,
                                controller: companyName,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
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
                            password.text.isEmpty ||
                            phoneNumber.text.isEmpty ||
                            companyName.text.isEmpty ||
                            location.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else if (image == null) {
                          Fluttertoast.showToast(
                              msg: 'Select a profile image!');
                        } else if (validateEmail(email.text) == null) {
                          checkDistributor();
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

class ContainerText extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final node;
  final bool hide;
  final int maxLength;
  final int maxLines;
  final TextInputType inputType;
  final double width;
  final double height;
  final bool enabled;
  final bool nextFocus;

  const ContainerText({
    Key key,
    this.controller,
    this.hint,
    this.node,
    this.hide,
    this.maxLength,
    this.maxLines,
    this.inputType,
    this.width,
    this.height,
    this.enabled,
    this.nextFocus,
  });

  @override
  _ContainerTextState createState() => _ContainerTextState();
}

class _ContainerTextState extends State<ContainerText> {
  bool show;

  //
  //
  // function to toggle visibility if password
  passwordVisibility() {
    if (widget.hide == true) {
      setState(() {
        show = false;
      });
    } else {
      setState(() {
        show = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    passwordVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 5,
            child: TextField(
              enabled: widget.enabled,
              keyboardType: widget.inputType,
              // hides the text if password
              obscureText: show == false ? true : false,
              controller: widget.controller,
              textInputAction: TextInputAction.next,
              maxLength: widget.maxLength,
              maxLines: widget.maxLines == null ? 1 : widget.maxLines,
              onEditingComplete: () =>
                  widget.nextFocus == true ? null : widget.node.nextFocus(),
              style: TextStyle(
                  color: widget.enabled == false ? Colors.grey[600] : null),
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                counterText: '',
                hintText: widget.hint,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          // shows a visibility button if password
          widget.hide != null
              ? Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(show == false
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        if (show == false) {
                          show = true;
                        } else
                          show = false;
                      });
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
