import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopupCard_Pharmacist extends StatelessWidget {
  final String dateTime;
  final String by;
  final String image;
  final String name;
  final String tag;
  double width;
  double height;

  PopupCard_Pharmacist({
    Key key,
    this.dateTime,
    this.by,
    this.image,
    this.name,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: tag,
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Text(
                          '$name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: width / 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: width / 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) => Container(
                          width: width / 15,
                          height: width / 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$by',
                        style: TextStyle(
                          fontSize: width / 25,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Last Changed - $dateTime',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: width / 30,
                    ),
                  ),
                  SizedBox(
                    height: height / 70,
                  ),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.red[400],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
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
