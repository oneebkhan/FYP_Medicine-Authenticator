import 'package:flutter/material.dart';

class Distributor extends StatefulWidget {
  final String dist;
  Distributor({Key key, @required this.dist}) : super(key: key);

  @override
  _DistributorState createState() => _DistributorState();
}

class _DistributorState extends State<Distributor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
