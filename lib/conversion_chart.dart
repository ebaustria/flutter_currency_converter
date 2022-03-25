import 'package:currency_picker/currency_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConversionChart extends StatefulWidget {
  const ConversionChart({
    Key? key,
    required this.conversionData,
  }) : super(key: key);
  final List<MapEntry<String, dynamic>> conversionData;

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
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 8,
        minY: minimumRate(),
        maxY: maximumRate(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: (maximumRate() - minimumRate()) / 10,
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
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 24,
            ),
            axisNameWidget: const Text('Dates'),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: leftTitleWidgets,
              showTitles: true,
              interval: (maximumRate() - minimumRate()) / 10,
              reservedSize: 34,
            ),
            axisNameWidget: const Text('Conversion Rate'),
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
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
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
