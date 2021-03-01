import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RowInfo extends StatelessWidget {
  final String location;
  final String imageURL;
  final String title;
  final double width;
  final Function func;

  const RowInfo({
    Key key,
    @required this.width,
    @required this.title,
    @required this.location,
    @required this.imageURL,
    @required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl:
                    // the 4th image URL
                    imageURL,
                imageBuilder: (context, imageProvider) => Container(
                  width: width / 8,
                  height: width / 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: width / 19,
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: width / 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
