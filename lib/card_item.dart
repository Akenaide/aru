import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      shops.add(new Chip(
        label: new Text(
          "$name : $price",
          overflow: TextOverflow.clip,
        ),
      ));
    });
    return new Column(
      children: shops,
    );
  }
}

class CardWidget extends StatefulWidget {
  final ShopCard _shopCard;
  final Function(String) _delete;
  final int index;

  CardWidget(this._shopCard, this._delete, this.index);

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<CardWidget> {
  _CardItemState();
  toggleBought(bool newValue) {
    setState(() {
      widget._shopCard.bought = newValue;
    });
  }

  void cacheSelectedCard(ShopCard selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedCard", selected.prepToString());
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        children: <Widget>[
          new Text(
            widget._shopCard.cardId,
          ),
          new Expanded(
            child: new Image.network(
              widget._shopCard.imageurl,
            ),
          ),
          new Text("Quantity : ${widget._shopCard.amount}"),
          new ShopRow(widget._shopCard),
        ],
      ),
    );
  }
}
