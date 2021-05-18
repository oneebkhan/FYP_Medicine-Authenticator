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
class AddMedicineModel extends StatefulWidget {
  @override
  _AddMedicineModelState createState() => _AddMedicineModelState();
}

class _AddMedicineModelState extends State<AddMedicineModel> {
  double width;
  double height;
  double safePadding;
  TextEditingController medName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController dose = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController description = TextEditingController();
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
              .ref('Medicine/${medName.text}/image$index2.png')
              .putFile(image[index2]);
          //getting the image url
          var downloadURL = await snapshot.ref.getDownloadURL();
          setState(() {
            uploadedFileURL.insert(index2, downloadURL);
          });
        }
        addMedicineModelInfo();
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
  addMedicineModelInfo() async {
    try {
      // ignore: await_only_futures
      var firestore = await FirebaseFirestore.instance;
      firestore.collection("MedicineModel").doc(medName.text).set({
        "name": medName.text,
        "activeIngredients": activeIngredients.text,
        "companyName": compName.text,
        "description": description.text,
        "dose": dose.text,
        "otherIngredients": otherIngredients.text,
        "price": price.text,
        "quantity": quantity.text,
        "sideEffects": sideEffects.text,
        "totalSales": 0,
        "uses": uses.text,
        "imageURL": uploadedFileURL,
        "lastEditedBy": {
          FirebaseAuth.instance.currentUser.email: Timestamp.now()
        },
      }).then((_) {
        Fluttertoast.showToast(msg: 'Medicine Model created Succesfully!');
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
                                'Add Medicine Model',
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
                                hint: 'Medicine Name',
                                node: node,
                                controller: medName,
                                maxLength: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Price',
                                controller: price,
                                inputType: TextInputType.phone,
                                node: node,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Dose (Xmg)',
                                controller: dose,
                                inputType: TextInputType.phone,
                                node: node,
                                maxLength: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Quantity (Xml or X tablets)',
                                node: node,
                                controller: quantity,
                                maxLength: 15,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Description',
                                node: node,
                                controller: description,
                                maxLength: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Active Ingredients',
                                node: node,
                                controller: activeIngredients,
                                maxLength: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Other Ingredients',
                                node: node,
                                controller: otherIngredients,
                                maxLength: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Side Effects',
                                node: node,
                                controller: sideEffects,
                                maxLength: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Uses',
                                node: node,
                                controller: uses,
                                maxLength: 300,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ContainerText(
                                hint: 'Company Name',
                                node: node,
                                controller: compName,
                                maxLength: 300,
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
                        } else if (medName.text.isEmpty ||
                            activeIngredients.text.isEmpty ||
                            compName.text.isEmpty ||
                            description.text.isEmpty ||
                            dose.text.isEmpty ||
                            otherIngredients.text.isEmpty ||
                            price.text.isEmpty ||
                            quantity.text.isEmpty ||
                            sideEffects.text.isEmpty ||
                            uses.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Fill all the fields!');
                        } else if (image == []) {
                          Fluttertoast.showToast(msg: 'Select an image');
                        } else {
                          uploadFile();
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
              onEditingComplete: () => widget.node.nextFocus(),
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
