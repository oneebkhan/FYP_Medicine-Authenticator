import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tracker_admin/configs/mobile.dart';

class BarChartMonthly extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  final double width;
  int jan;
  int feb;
  int mar;
  int apr;
  int may;
  int jun;
  int jul;
  int aug;
  int sep;
  int oct;
  int nov;
  int dec;

  BarChartMonthly({
    this.width,
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  @override
  State<StatefulWidget> createState() => BarChartMonthlyState();
}

class BarChartMonthlyState extends State<BarChartMonthly> {
  final Color barBackgroundColor = const Color.fromARGB(255, 149, 191, 255);
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
      'Monthly Summary',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTRB(0, 100, 0, 0),
    );
    page.graphics.drawString(
      'This document is for the administrator or the equivalent \nauthority to view the sales in the year, in a monthly format. \nThe information is confidential and should not be shared \noutside the organisation unless given permission.',
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
    header.cells[0].value = 'Months';
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
    row.cells[0].value = 'January';
    row.cells[1].value = widget.jan.toString();

    row = grid.rows.add();
    row.cells[0].value = 'Febuary';
    row.cells[1].value = widget.feb.toString();

    row = grid.rows.add();
    row.cells[0].value = 'March';
    row.cells[1].value = widget.mar.toString();

    row = grid.rows.add();
    row.cells[0].value = 'April';
    row.cells[1].value = widget.apr.toString();

    row = grid.rows.add();
    row.cells[0].value = 'May';
    row.cells[1].value = widget.may.toString();

    row = grid.rows.add();
    row.cells[0].value = 'June';
    row.cells[1].value = widget.jun.toString();

    row = grid.rows.add();
    row.cells[0].value = 'July';
    row.cells[1].value = widget.jul.toString();

    row = grid.rows.add();
    row.cells[0].value = 'August';
    row.cells[1].value = widget.aug.toString();

    row = grid.rows.add();
    row.cells[0].value = 'September';
    row.cells[1].value = widget.sep.toString();

    row = grid.rows.add();
    row.cells[0].value = 'October';
    row.cells[1].value = widget.oct.toString();

    row = grid.rows.add();
    row.cells[0].value = 'November';
    row.cells[1].value = widget.nov.toString();

    row = grid.rows.add();
    row.cells[0].value = 'December';
    row.cells[1].value = widget.dec.toString();
    //----------------rows end here---------------------

    //drawing the table on the pdf
    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Monthly.pdf');
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
              'Monthly',
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
                    color: Color.fromARGB(255, 160, 197, 255),
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
    Color barColor = const Color.fromARGB(255, 109, 141, 225),
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
            y: 10,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(12, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, widget.jan.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, widget.feb.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, widget.mar.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, widget.apr.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, widget.may.toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, widget.jun.toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, widget.jul.toDouble(),
                isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(7, widget.aug.toDouble(),
                isTouched: i == touchedIndex);
          case 8:
            return makeGroupData(8, widget.sep.toDouble(),
                isTouched: i == touchedIndex);
          case 9:
            return makeGroupData(9, widget.oct.toDouble(),
                isTouched: i == touchedIndex);
          case 10:
            return makeGroupData(10, widget.nov.toDouble(),
                isTouched: i == touchedIndex);
          case 11:
            return makeGroupData(11, widget.dec.toDouble(),
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
                  weekDay = 'January';
                  break;
                case 1:
                  weekDay = 'Febuary';
                  break;
                case 2:
                  weekDay = 'March';
                  break;
                case 3:
                  weekDay = 'April';
                  break;
                case 4:
                  weekDay = 'May';
                  break;
                case 5:
                  weekDay = 'June';
                  break;
                case 6:
                  weekDay = 'July';
                  break;
                case 7:
                  weekDay = 'August';
                  break;
                case 8:
                  weekDay = 'September';
                  break;
                case 9:
                  weekDay = 'October';
                  break;
                case 10:
                  weekDay = 'November';
                  break;
                case 11:
                  weekDay = 'December';
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
                return 'J';
              case 1:
                return 'F';
              case 2:
                return 'M';
              case 3:
                return 'A';
              case 4:
                return 'M';
              case 5:
                return 'J';
              case 6:
                return 'J';
              case 7:
                return 'A';
              case 8:
                return 'S';
              case 9:
                return 'O';
              case 10:
                return 'N';
              case 11:
                return 'D';
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
                return 'Jan';
              case 1:
                return 'Feb';
              case 2:
                return 'Mar';
              case 3:
                return 'Apr';
              case 4:
                return 'May';
              case 5:
                return 'Jun';
              case 6:
                return 'Jul';
              case 7:
                return 'Aug';
              case 8:
                return 'Sep';
              case 9:
                return 'Oct';
              case 10:
                return 'Nov';
              case 11:
                return 'Dec';

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
          case 7:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 8:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 9:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 10:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 11:
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
