import 'package:flutter/material.dart';

import 'package:aru/card.dart';

class CardItem extends StatefulWidget {
  final ShopCard _shopCard;

  CardItem(this._shopCard);

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<CardItem> {
  _CardItemState();

  toggleBought(bool newValue) {
    setState(() {
      widget._shopCard.bought = newValue;
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
              widget._shopCard.cardId,
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Text(
              widget._shopCard.stores.toString(),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Checkbox(
              value: widget._shopCard.bought,
              onChanged: toggleBought,
            )
          ],
        ),
      ],
    );
  }
}
