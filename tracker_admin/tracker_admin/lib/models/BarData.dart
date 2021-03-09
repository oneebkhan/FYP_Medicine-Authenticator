import 'package:flutter/material.dart';

class Bars_Data {
  final int id;
  final String name;
  final double y;

  const Bars_Data({
    @required this.id,
    @required this.y,
    @required this.name,
  });
}

class BarData_Weekly_Admin {
  static List<Bars_Data> barData = [
    Bars_Data(
      id: 0,
      name: 'Mon',
      y: 15,
    ),
    Bars_Data(
      id: 1,
      name: 'Tue',
      y: 10,
    ),
    Bars_Data(
      id: 2,
      name: 'Wed',
      y: 9,
    ),
    Bars_Data(
      id: 3,
      name: 'Thu',
      y: 15,
    ),
    Bars_Data(
      id: 4,
      name: 'Fri',
      y: 6,
    ),
    Bars_Data(
      id: 5,
      name: 'Sat',
      y: 0,
    ),
    Bars_Data(
      id: 6,
      name: 'Sun',
      y: 2,
    ),
  ];
}
