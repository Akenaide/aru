import 'package:flutter/material.dart';

import 'package:aru/card.dart';

class ShopRow extends StatefulWidget {
  final ShopCard _shopCard;

  ShopRow(this._shopCard);

  @override
  _ShopRowState createState() => new _ShopRowState();
}

class _ShopRowState extends State<ShopRow> {
  _ShopRowState();

  @override
  Widget build(BuildContext context) {
    List<Widget> shops = [];
    widget._shopCard.stores.forEach((String name, int price) {
      shops.add(new Row(
        children: <Widget>[new Text("$name : $price")],
      ));
    });
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: shops,
    );
  }
}

class Cardrow extends StatefulWidget {
  final ShopCard _shopCard;

  Cardrow(this._shopCard);

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<Cardrow> {
  _CardItemState();
  toggleBought(bool newValue) {
    setState(() {
      widget._shopCard.bought = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new SizedBox(
            width: 80.0,
            child: new Text(
              widget._shopCard.cardId,
            )),
        new SizedBox(
          width: 80.0,
          child: new ShopRow(widget._shopCard),
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
