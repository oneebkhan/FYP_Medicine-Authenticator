import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tracker/Utils/CoronaModel.dart';
import 'package:tracker/screens/CoronaTips.dart';
import 'package:tracker/screens/Tips.dart';

class Corona extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final String status;
  final String description;
  final Widget widget;

  Corona({
    Key key,
    this.width,
    this.height,
    this.widget,
    this.title,
    this.status,
    this.description,
  });

  @override
  _CoronaState createState() => _CoronaState();
}

//
//
// API to get number or corona cases
class _CoronaState extends State<Corona> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        highlightColor: Colors.white10,
        focusColor: Colors.white10,
        splashColor: Colors.white10,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CoronaTips(),
            ),
          );
        },
        child: Ink(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 228, 89, 86),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: widget.width / 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Center(
                      child: widget.widget,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 5),
                      child: Container(
                        width: widget.width / 2.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.title} - ${widget.status}',
                              style: TextStyle(
                                fontSize: widget.width / 22,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            widget.description == null
                                ? SizedBox(
                                    width: widget.width / 2,
                                    height: widget.width / 20,
                                  )
                                : Text(
                                    widget.description,
                                    style: TextStyle(
                                      fontSize: widget.width / 27,
                                      fontFamily: 'Montserrat',
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Center(
                        child: Container(
                          width: widget.width / 2.9,
                          height: widget.width,
                          child: Image(
                            image: AssetImage('assets/images/corona.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Vaccination extends StatefulWidget {
  final double width;
  final double height;
  final String ageVaccination;

  const Vaccination({
    Key key,
    this.width,
    this.height,
    this.ageVaccination,
  });

  @override
  _VaccinationState createState() => _VaccinationState();
}

class _VaccinationState extends State<Vaccination> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        highlightColor: Colors.white10,
        focusColor: Colors.white10,
        splashColor: Colors.white10,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Tips(),
            ),
          );
        },
        child: Ink(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 51, 196, 129),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 5),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vaccine Centers',
                          style: TextStyle(
                            fontSize: widget.width / 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: widget.width / 2.2,
                          child: Text(
                            'Get vaccinated if you are ${widget.ageVaccination} years of age',
                            style: TextStyle(
                              fontSize: widget.width / 27,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            child: Center(
                              child: Text(
                                'Find Vaccination Centers',
                                style: TextStyle(
                                  fontSize: widget.width / 29,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Center(
                    child: Container(
                      width: widget.width / 3.2,
                      height: widget.width,
                      child: Image(
                        image: AssetImage('assets/images/vaccine.png'),
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

class TipsCarosel extends StatefulWidget {
  final double width;
  final double height;

  const TipsCarosel({
    Key key,
    this.width,
    this.height,
  });

  @override
  _TipsCaroselState createState() => _TipsCaroselState();
}

class _TipsCaroselState extends State<TipsCarosel> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        highlightColor: Colors.white10,
        focusColor: Colors.white10,
        splashColor: Colors.white10,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Tips(),
            ),
          );
        },
        child: Ink(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 149, 191, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 5),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips',
                          style: TextStyle(
                            fontSize: widget.width / 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: widget.width / 2.2,
                          child: Text(
                            'Learn how to spot fake or tampered medicine',
                            style: TextStyle(
                              fontSize: widget.width / 27,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 9),
                            child: Center(
                              child: Text(
                                'Go to the Tips Section',
                                style: TextStyle(
                                  fontSize: widget.width / 27,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Center(
                    child: Container(
                      width: widget.width / 3.2,
                      height: widget.width,
                      child: Image(
                        image: AssetImage('assets/images/tip.png'),
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
