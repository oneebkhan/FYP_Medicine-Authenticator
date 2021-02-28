import 'package:flutter/material.dart';
import 'package:tracker/Widgets/InfoContainer.dart';

class Pharmacies extends StatefulWidget {
  Pharmacies({Key key}) : super(key: key);

  @override
  _PharmaciesState createState() => _PharmaciesState();
}

class _PharmaciesState extends State<Pharmacies> {
  var width;
  var height;
  var safePadding;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    safePadding = MediaQuery.of(context).padding.top;
    var contHeight;

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
                'Pharmacies',
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
              InfoContainer(
                color: Colors.green,
                description: '5 Pharmacies',
                func: null,
                imageUrls: [
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                ],
                title: 'Hajji Ltd.',
                width: width,
              ),
              InfoContainer(
                color: Colors.green,
                description: '5 Pharmacies',
                func: null,
                imageUrls: [
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                  'https://picsum.photos/250?image=9',
                ],
                title: 'Hajji Ltd.',
                width: width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}