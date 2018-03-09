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

  toggleBought(bool newValue) {
    setState(() {
      _shopCard.bought = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Text(
              _shopCard.cardId,
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Text(
              _shopCard.stores.toString(),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Checkbox(
              value: _shopCard.bought,
              onChanged: toggleBought,
            )
          ],
        ),
      ],
    );
  }
}
