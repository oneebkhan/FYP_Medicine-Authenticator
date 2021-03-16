import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InfoContainer extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final String title;
  final String description;
  final List<String> imageUrls;
  final Function func;
  final int countOfImages;

  const InfoContainer({
    @required this.width,
    @required this.height,
    @required this.color,
    @required this.title,
    @required this.description,
    @required this.imageUrls,
    @required this.func,
    @required this.countOfImages,
  });

  @override
  _InfoContainerState createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          widget.func();
        },
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: widget.width / 35,
                        height: widget.width / 6,
                        decoration: BoxDecoration(
                          //
                          //
                          // The container color
                          color: widget.color,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.width / 18,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: widget.width / 28,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: widget.width / 9,
                                  width: widget.width / 1.5,
                                  child: ListView.builder(
                                    //itemExtent: 4,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.countOfImages > 4
                                        ? 4
                                        : widget.countOfImages,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CachedNetworkImage(
                                        imageUrl:
                                            // the 4th image URL
                                            widget.imageUrls[index],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: widget.width / 9,
                                          height: widget.width / 9,
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
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
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
