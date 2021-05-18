import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracker_admin/Widgets/PopupCard.dart';
import 'package:tracker_admin/Widgets/RowInfo.dart';
import 'package:tracker_admin/configs/HeroDialogRoute.dart';
import 'package:tracker_admin/screens/Pharmacy_Clinics_Info.dart';

class History extends StatefulWidget {
  // The name of the category opened

  const History({
    Key key,
  }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  double opac;
  var historyStream;

  //
  //
  // get pharmacies
  getHistory() async {
    try {
      setState(() {
        historyStream = FirebaseFirestore.instance
            .collection('History')
            .orderBy('timestamp', descending: false)
            .snapshots();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    opac = 0;
    getHistory();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opac = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                  'History',
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
                        bottom: 20,
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: historyStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData == false) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                QueryDocumentSnapshot item =
                                    snapshot.data.docs[index];
                                return Hero(
                                  tag: 'popupContainer',
                                  child: Material(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                    child: RowInfo(
                                      imageURL: item['image'] == ''
                                          ? 'http://www.spicefactors.com/wp-content/uploads/default-user-image.png'
                                          : item['image'],
                                      location: item['by'],
                                      width: width,
                                      title: item['name'],
                                      func: () {
                                        Navigator.of(context).push(
                                            HeroDialogRoute(builder: (context) {
                                          return PopupCard(
                                            by: item['by'].toString(),
                                            dateTime: DateFormat.yMMMd()
                                                .add_jm()
                                                .format(
                                                    item['timestamp'].toDate())
                                                .toString(),
                                            image: item['image'],
                                            name: item['name'],
                                          );
                                        }));
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
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
