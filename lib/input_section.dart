import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputSection extends StatefulWidget {
  const InputSection({
    Key? key,
    required this.onTextChanged,
    required this.performConversion,
  }) : super(key: key);
  final Function(String) onTextChanged;
  final Function(String, String) performConversion;

  @override
  _InputSectionState createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  Map<String, dynamic> _baseCurrency = {'code': 'USD',
    'emoji': '🇺🇸', 'symbol': '\$'};
  Map<String, dynamic> _targetCurrency = {'code': 'EUR',
    'emoji': '🇪🇺', 'symbol': '€'};
  final _baseController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
  }

  void selectCurrency(Currency currency, bool isBase) {
    var newCurrency = {
      'code': currency.code,
      'emoji': CurrencyUtils.currencyToEmoji(currency),
      'symbol': currency.symbol
    };
    if (isBase) {
      setState(() {
        _baseCurrency = newCurrency;
      });
      return;
    }
    setState(() {
      _targetCurrency = newCurrency;
    });
  }

  void swapCurrencies() {
    var newBase = _targetCurrency;
    var newTarget = _baseCurrency;
    setState(() {
      _baseCurrency = newBase;
      _targetCurrency = newTarget;
    });
  }

  Widget buildRow(String text, bool isBase) {
    Map<String, dynamic> currency = isBase ? _baseCurrency : _targetCurrency;
    const flexSize = 3;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          flex: flexSize,
        ),
        const Spacer(),
        Flexible(
          flex: flexSize,
          child: ElevatedButton(
            onPressed: () {
              showCurrencyPicker(
                context: context,
                onSelect: (currency) => selectCurrency(currency, isBase),
              );
            },
            child: Text(currency['emoji'] + '     ' + currency['symbol'])
          ),
        ),
        const Spacer(),
        if (isBase) ...[
          Flexible(
            flex: flexSize,
            child: TextField(
              controller: _baseController,
              keyboardType: TextInputType.number,
              onChanged: widget.onTextChanged,
              style: const TextStyle(color: Colors.white,),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Flexible(
              flex: 2,
              child: buildRow('From:  ', true),
            ),
            const Spacer(),
            Flexible(
              flex: 2,
              child: ElevatedButton(
                  onPressed: swapCurrencies,
                  child: const Icon(MdiIcons.swapVertical)
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 2,
              child: buildRow('To:', false),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => widget.performConversion(_baseCurrency['code'], _targetCurrency['code']),
              child: const Text('Convert'),
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                minimumSize: const Size.fromHeight(45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _baseController.dispose();
    super.dispose();
  }
}
