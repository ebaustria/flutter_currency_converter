import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        scaffoldBackgroundColor: Colors.blueGrey,
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
  String _conversionResult = "0";
  String _baseAmount = "1";

  Uri getURL(String base, String target) {
    String q = base + '_' + target;
    return Uri.https('free.currconv.com', '/api/v7/convert',
      {
        'q': q,
        'compact': 'ultra',
        'apiKey': '3fc84b927a85e151b011',
      },
    );
  }

  Future<void> performConversion(String base, String target) async {
    var response = await http.get(getURL(base, target));
    if (response.statusCode == 200) {
      print("SUCCESS");
      print(response.body);
    }
  }

  void onBaseAmountChanged(String amount) {
    setState(() {
      _baseAmount = amount;
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
          Text(_conversionResult, style: const TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}
