import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PopupCard extends StatelessWidget {
  final String dateTime;
  final String by;
  final String image;
  final String name;
  double width;
  double height;

  PopupCard({
    Key key,
    this.dateTime,
    this.by,
    this.image,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'popupContainer',
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width / 16,
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Row(
                      children: [
                        Text(
                          'Done by:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width / 25,
                          ),
                        ),
                        SizedBox(
                          width: width / 20,
                        ),
                        CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                            width: width / 12,
                            height: width / 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('$by')
                      ],
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Row(
                      children: [
                        Text(
                          'Last Changed:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width / 25,
                          ),
                        ),
                        SizedBox(
                          width: width / 20,
                        ),
                        Text('$dateTime')
                      ],
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Center(
                      child: TextButton(
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
      ),
    );
  }
}
