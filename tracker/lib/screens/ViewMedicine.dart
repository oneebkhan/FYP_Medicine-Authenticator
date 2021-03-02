import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracker/Widgets/InfoContainer.dart';
import 'package:tracker/Widgets/RowInfo.dart';
import 'package:tracker/screens/About.dart';
import 'package:tracker/screens/MedicineInfo.dart';

class ViewMedicine extends StatefulWidget {
  // The name of the category opened
  final String pageName;
  final List<String> imageUrls;
  final List<String> location;
  final List<String> title;
  final List<Function> func;

  const ViewMedicine({
    Key key,
    @required this.pageName,
    @required this.imageUrls,
    @required this.location,
    @required this.title,
    @required this.func,
  }) : super(key: key);

  @override
  _ViewMedicineState createState() => _ViewMedicineState();
}

class _ViewMedicineState extends State<ViewMedicine> {
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
                          imageURL: widget.imageUrls[0],
                          location: widget.location[0],
                          width: width,
                          title: widget.title[0],
                          func: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicineInfo(),
                              ),
                            );
                          },
                        ),
                        RowInfo(
                          imageURL: widget.imageUrls[1],
                          location: widget.location[1],
                          width: width,
                          title: widget.title[1],
                          func: () {
                            widget.func[1]();
                          },
                        ),
                        RowInfo(
                          imageURL: widget.imageUrls[2],
                          location: widget.location[2],
                          width: width,
                          title: widget.title[2],
                          func: () {
                            widget.func[2]();
                          },
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
    );
  }
}
