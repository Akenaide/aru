import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/globals.dart';

class TotalPrice extends StatefulWidget {
  final List<ShopCard> _cardList;
  @override
  _TotalPriceState createState() => _TotalPriceState();

  TotalPrice(this._cardList);

  String get _total {
    int sum = 0;
    for (var card in _cardList) {
      try {
        var val = card.stores["yyt"] * (card.amount - card.nbBought);
        if (val > 0) {
          sum = sum + val;
        }
      } catch (NoSuchMethodError) {
        continue;
      }
    }
    return intlNumber.format(sum);
  }
}

class _TotalPriceState extends State<TotalPrice> {
  @override
  void initState() {
    super.initState();
    quantityStream.stream.listen((data) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    quantityStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Card(child: new Text("Total : ${widget._total}")),
    );
  }
}
