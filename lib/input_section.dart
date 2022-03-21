import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class InputSection extends StatefulWidget {
  const InputSection({Key? key, required this.onTextChanged,}) : super(key: key);
  final Function(String?) onTextChanged;

  @override
  _InputSectionState createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  Map<String, dynamic> _baseCurrency = {"emoji": "🇺🇸", "symbol": "\$"};
  Map<String, dynamic> _targetCurrency = {"emoji": "🇪🇺", "symbol": "€"};

  @override
  void initState() {
    super.initState();
  }

  void selectCurrency(Currency currency, bool isBase) {
    var newCurrency = {"emoji": CurrencyUtils.currencyToEmoji(currency), "symbol": currency.symbol};
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

  void performConversion() {
    print("CONVERT");
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
            style: const TextStyle(fontSize: 18),
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
              child: Text(currency["emoji"] + "     " + currency["symbol"])
          ),
        ),
        const Spacer(),
        if (isBase) ...[
          Flexible(
            flex: flexSize,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: widget.onTextChanged,
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
              onPressed: performConversion,
              child: const Text("Convert"),
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
}
