import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracker/Widgets/InfoContainer.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/About.dart';

class ViewPharmacyOrClinic extends StatefulWidget {
  // The name of the category opened
  final String pageName;

  const ViewPharmacyOrClinic({Key key, @required this.pageName})
      : super(key: key);

  @override
  _ViewPharmacyOrClinicState createState() => _ViewPharmacyOrClinicState();
}

class _ViewPharmacyOrClinicState extends State<ViewPharmacyOrClinic> {
  double opac;
  @override
  void initState() {
    super.initState();
    opac = 0;

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var safePadding = MediaQuery.of(context).padding.top;

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
                  widget.pageName,
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
                        top: 20,
                      ),
                      child: Column(
                        children: [
                          //
                          //
                          // The row in the Field
                          RowInfo(
                            imageURL: 'https://picsum.photos/250?image=9',
                            location: 'Laal Kurti, 220, cake lane',
                            width: width,
                            title: 'Hajji Ltd. Iqbal Town',
                            func: () {},
                          ),
                          RowInfo(
                            imageURL: 'https://picsum.photos/250?image=9',
                            location: 'Laal Kurti, 220, cake lane',
                            width: width,
                            title: 'Hajji Ltd. Iqbal Town',
                            func: () {},
                          ),
                          RowInfo(
                            imageURL: 'https://picsum.photos/250?image=9',
                            location: 'Laal Kurti, 220, cake lane',
                            width: width,
                            title: 'Hajji Ltd. Iqbal Town',
                            func: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
