import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'currency_data.dart';

class InputSection extends StatelessWidget {
  InputSection({
    Key? key,
    required this.onTextChanged,
    required this.performConversion,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.onSwapCurrencies,
    required this.onSelectCurrency,
  }) : super(key: key);
  final Function(String) onTextChanged;
  final Function(String, String) performConversion;
  final Function() onSwapCurrencies;
  final Function(Currency currency, bool isBase) onSelectCurrency;
  final CurrencyData baseCurrency;
  final CurrencyData targetCurrency;

  final _baseController = TextEditingController(text: '1');

  Widget buildRow(String text, BuildContext context, bool isBase) {
    CurrencyData currency = isBase ? baseCurrency : targetCurrency;
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
                  onSelect: (currency) => onSelectCurrency(currency, isBase),
                );
              },
              child: Text(currency.emoji + '     ' + currency.symbol)
          ),
        ),
        const Spacer(),
        if (isBase) ...[
          Flexible(
            flex: flexSize,
            child: TextField(
              controller: _baseController,
              keyboardType: TextInputType.number,
              onChanged: onTextChanged,
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
              child: buildRow('From:  ', context, true),
            ),
            const Spacer(),
            Flexible(
              flex: 2,
              child: ElevatedButton(
                  onPressed: onSwapCurrencies,
                  child: const Icon(MdiIcons.swapVertical)
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 2,
              child: buildRow('To:', context, false),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => performConversion(baseCurrency.code, targetCurrency.code),
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
}
