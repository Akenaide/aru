import 'package:flutter/material.dart';

import 'package:aru/card.dart';

class CardItem extends StatefulWidget {
  final ShopCard _shopCard;
  CardItem(this._shopCard);

  @override
  _CardItemState createState() => new _CardItemState(_shopCard);
}

class _CardItemState extends State<CardItem> {
    final ShopCard _shopCard;
  _CardItemState(this._shopCard);
  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Text("yay")
    ],
    );
  }
  // final ShopCard shopCard = new ShopCard();
  // @override
  // Widget build(BuildContext context) {
  //   return new Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       new Column(
  //         children: <Widget>[
  //           new Text(
  //             shopCard.cardId,
  //           )
  //         ],
  //       ),
  //       new Column(
  //         children: <Widget>[
  //           new Text(
  //             shopCard.stores.toString(),
  //           )
  //         ],
  //       ),
  //       new Column(
  //         children: <Widget>[
  //           new Checkbox(
  //             value: shopCard.bought,
  //             onChanged: (bool newValue) {
  //               shopCard.bought = newValue;
  //             },
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }
}
