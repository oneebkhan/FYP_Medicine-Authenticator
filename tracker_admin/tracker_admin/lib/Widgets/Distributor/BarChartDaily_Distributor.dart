import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tracker_admin/configs/mobile.dart';

class BarChartDaily_Distributor extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  final double width;
  final int mon;
  final int tues;
  final int wed;
  final int thurs;
  final int fri;
  final int sat;
  final int sun;

  BarChartDaily_Distributor({
    this.width,
    this.mon,
    this.tues,
    this.wed,
    this.thurs,
    this.fri,
    this.sat,
    this.sun,
  });

  @override
  State<StatefulWidget> createState() => BarChartDaily_DistributorState();
}

class BarChartDaily_DistributorState extends State<BarChartDaily_Distributor> {
  final Color barBackgroundColor = const Color.fromARGB(255, 148, 210, 146);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;
  bool isPlaying = false;

  //
  //
  // makes a pdf summary
  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    //the image at the top
    page.graphics.drawImage(
      PdfBitmap(await _readImageData('FYP.png')),
      Rect.fromLTRB(0, 0, 0, 0),
    );

    //The top heading
    page.graphics.drawString(
      'Daily Summary',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTRB(0, 100, 0, 0),
    );
    page.graphics.drawString(
      'This document is for the distributor or the equivalent \nauthority to view the sales in the week, in a daily format. \nThe information is confidential and should not be shared \noutside the organisation unless given permission.',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTRB(0, 150, 0, 0),
    );
    page.graphics.drawString(
      'Compiled On: ' +
          DateFormat.yMMMd().add_jm().format(DateTime.now()).toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTRB(0, 270, 0, 0),
    );

    //making a table
    PdfGrid grid = PdfGrid();
    //theme
    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 25),
      cellPadding: PdfPaddings(
        left: 5,
        right: 2,
        top: 2,
        bottom: 2,
      ),
    );
    grid.columns.add(count: 2);
    grid.headers.add(1);

    //making the table headers
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Day';
    header.cells[1].value = 'Sales';
    grid.headers.applyStyle(PdfGridRowStyle(
      font: PdfStandardFont(
        PdfFontFamily.helvetica,
        25,
        style: PdfFontStyle.bold,
      ),
    ));

    //---------------Rows in the table-----------------
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Monday';
    row.cells[1].value = widget.mon.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Tuesday';
    row.cells[1].value = widget.tues.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Wednesday';
    row.cells[1].value = widget.wed.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Thursday';
    row.cells[1].value = widget.thurs.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Friday';
    row.cells[1].value = widget.fri.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Saturday';
    row.cells[1].value = widget.sat.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Sunday';
    row.cells[1].value = widget.sun.toString();
    //----------------rows end here---------------------

    //drawing the table on the pdf
    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Daily_Distributor.pdf');
  }

  //
  //
  //show image in the pdf file
  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/icons/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Material(
              color: Colors.transparent,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100.0))),
              child: InkWell(
                splashColor: Colors.white.withOpacity(0.5),
                onTap: () {
                  _createPDF();
                },
                customBorder: CircleBorder(),
                child: Ink(
                  width: widget.width / 10,
                  height: widget.width / 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 112, 159, 110),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: widget.width / 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: BarChart(
            isPlaying ? randomData() : mainBarData(),
            swapAnimationDuration: animDuration,
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color.fromARGB(255, 112, 159, 110),
    double width = 5,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.red[200]] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 5,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, widget.mon.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, widget.tues.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, widget.wed.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, widget.thurs.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, widget.fri.toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, widget.sat.toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, widget.sun.toDouble(),
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.red[200]));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
