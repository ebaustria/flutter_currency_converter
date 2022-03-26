import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/conversion_chart.dart';
import 'package:http/http.dart' as http;
import 'conversion.dart';
import 'input_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _conversionResult = 0;
  List<MapEntry<String, dynamic>> _historicalConversions = [];
  double _baseAmount = 1;

  @override
  void initState() {
    super.initState();
    performConversion('USD', 'EUR');
  }

  Uri getURL(String base, String target) {
    String q = base + '_' + target;
    DateTime today = DateTime.now();
    DateTime startDate = today.subtract(const Duration(days: 8));
    String endDate = today.year.toString() + '-' + today.month.toString()
        + '-' + today.day.toString();
    String date = startDate.year.toString() + '-' + startDate.month.toString()
        + '-' + startDate.day.toString();
    return Uri.https('free.currconv.com', '/api/v7/convert',
      {
        'q': q,
        'compact': 'ultra',
        'date': date,
        'endDate': endDate,
        'apiKey': '3fc84b927a85e151b011',
      },
    );
  }

  Future<void> performConversion(String base, String target) async {
    http.Response response = await http.get(getURL(base, target));
    if (response.statusCode == 200) {
      var conversion = Conversion.fromJson(jsonDecode(response.body));
      setState(() {
        _historicalConversions = conversion.conversionRate.entries.toList();
        _conversionResult = conversion.conversionRate.values.last * _baseAmount;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void onBaseAmountChanged(String amount) {
    setState(() {
      _baseAmount = double.tryParse(amount)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputSection(
            onTextChanged: onBaseAmountChanged,
            performConversion: performConversion,
          ),
          Text(
            _conversionResult.toString(),
            style: const TextStyle(fontSize: 32),
          ),
          SizedBox(
            height: 200,
            width: 300,
            child: ConversionChart(conversionData: _historicalConversions,),
          ),
        ],
      ),
    );
  }
}
