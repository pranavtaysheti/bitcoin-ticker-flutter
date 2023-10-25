import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/api.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as io;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  List<double> currencyPrices = List.filled(cryptoList.length, 0.00);

  @override
  void initState() {
    super.initState();
    updateUI(selectedCurrency);
  }

  void updateUI(String currency) async {
    List<double> newPrices = List.filled(cryptoList.length, 0.00);

    for (final (index, item) in cryptoList.indexed) {
      newPrices[index] = await getCoinRate(item, currency);
    }

    setState(() {
      selectedCurrency = currency;
      for (int i = 0; i < cryptoList.length; i++) {
        currencyPrices[i] = newPrices[i];
      }
    });
  }

  Widget currencySelectMenu() {
    if (io.Platform.isIOS) {
      return CupertinoPicker(
        itemExtent: 32.00,
        children: currenciesList.map((e) => Text(e)).toList(),
        onSelectedItemChanged: (value) => updateUI(currenciesList[value]),
      );
    }
    return DropdownButton(
      items: currenciesList
          .map(
            (e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ),
          )
          .toList(),
      value: selectedCurrency,
      onChanged: (value) => {
        if (value != null) {updateUI(value)}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cryptoList
                    .mapIndexed(
                      (i, e) => Card(
                        color: Colors.lightBlueAccent,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 28.0),
                          child: Text(
                            '1 $e = ${currencyPrices[i].toStringAsFixed(2)} $selectedCurrency',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: currencySelectMenu(),
          ),
        ],
      ),
    );
  }
}
