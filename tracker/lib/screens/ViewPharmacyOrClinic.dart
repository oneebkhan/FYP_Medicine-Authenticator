import 'package:flutter/material.dart';

class ViewPharmacyOrClinic extends StatefulWidget {
  final String pageName;
  final bool admin;

  const ViewPharmacyOrClinic(
      {Key key, @required this.pageName, @required this.admin})
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: (width / 50) + safePadding,
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
                  child: Column(
                    children: [],
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
