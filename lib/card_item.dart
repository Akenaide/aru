import 'package:flutter/material.dart';

import 'package:aru/card.dart';

class CardItem extends StatelessWidget {

  CardItem({Key key, this.shopCard}) : super(key: key);

  final ShopCard shopCard;

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new Text(
              shopCard.cardId,
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Text(
              shopCard.stores.toString(),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new Text(
              shopCard.bought.toString(),
            )
          ],
        ),
      ],
    );
  }
}