import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/currency_data.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConversionChart extends StatefulWidget {
  const ConversionChart({
    Key? key,
    required this.conversionData,
    required this.gradientColors,
    required this.baseCurrency,
    required this.targetCurrency,
  }) : super(key: key);
  final List<MapEntry<String, dynamic>> conversionData;
  final List<Color> gradientColors;
  final CurrencyData baseCurrency;
  final CurrencyData targetCurrency;

  @override
  _ConversionChartState createState() => _ConversionChartState();
}

class _ConversionChartState extends State<ConversionChart> {

  @override
  void initState() {
    super.initState();
  }

  List<FlSpot> processBarData() {
    return widget.conversionData.map((MapEntry<String, dynamic> entry) =>
      FlSpot(
          widget.conversionData.indexOf(entry).toDouble(),
          entry.value as double
      )
    ).toList();
  }

  double minimumRate() {
    return widget.conversionData.reduce((elA, elB) => elA.value < elB.value
        ? elA : elB).value;
  }

  double maximumRate() {
    return widget.conversionData.reduce((elA, elB) => elA.value > elB.value
        ? elA : elB).value;
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    int precisionLevel = value.toString().split('.')[0].length > 1 ? 1 : 4;
    if (value == maximumRate() + horizontalInterval() || value == minimumRate() - horizontalInterval()) {
      return Container();
    }
    return Text(value.toStringAsFixed(precisionLevel), style: style, textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(widget.conversionData[0].key, style: style);
        break;
      case 4:
        text = Text(widget.conversionData[4].key, style: style);
        break;
      case 8:
        text = Text(widget.conversionData[8].key, style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(
        child: Transform.rotate(
          angle: 15 * pi / 180,
          child: text,
        ),
        padding: const EdgeInsets.only(top: 9.0),
    );
  }

  double horizontalInterval() => (maximumRate() - minimumRate()) / 10;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 8,
        minY: minimumRate() - horizontalInterval(),
        maxY: maximumRate() + horizontalInterval(),
        clipData: FlClipData.vertical(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: horizontalInterval(),
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,

          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, meta) => Container(),
            ),
            axisNameWidget: Text(
              'Conversion Rates ' + widget.baseCurrency.code + ' => ' + widget.targetCurrency.code,
              style: TextStyle(color: Colors.white,),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: bottomTitleWidgets,
              showTitles: true,
              interval: 1,
              reservedSize: 24,
            ),
            axisNameWidget: const Text(
              'Dates',
              style: TextStyle(color: Colors.white,),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: horizontalInterval(),
              reservedSize: 34,
            ),
            axisNameWidget: const Text(
              'Conversion Rate',
              style: TextStyle(color: Colors.white,),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: processBarData(),
            isCurved: true,
            barWidth: 4,
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: widget.gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),

    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
