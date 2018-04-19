import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:aru/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopWidget extends StatefulWidget {
  final Shop shop;

  ShopWidget(this.shop);

  @override
  _ShopState createState() => new _ShopState();
}

class _ShopState extends State<ShopWidget> {
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _priceCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Flexible(
          child: new TextField(
            decoration: new InputDecoration(
              hintText: "Shop",
            ),
            controller: _nameCtrl,
          ),
        ),
        new Flexible(
          child: new TextField(
            decoration: new InputDecoration(
              hintText: "Price",
            ),
            keyboardType: TextInputType.number,
            onChanged: (_val) => setState(() {
                  widget.shop.price = int.parse(_val);
                }),
          ),
        ),
      ],
    );
  }
}

class AddElementWidget extends StatefulWidget {
  final ShopCard shopCard;
  final List<Shop> shopList = [
    new Shop(),
  ];

  AddElementWidget(this.shopCard);

  @override
  _AddElement createState() => new _AddElement();
}

class _AddElement extends State<AddElementWidget> {
  final TextEditingController _cardIdCtrl = new TextEditingController();

  _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.shopList.forEach((Shop shop) {
      widget.shopCard.stores[shop.name] = shop.price;
    });
    widget.shopCard.cardId = _cardIdCtrl.text;
    List<String> prevCards = [];
    prevCards.addAll(prefs.getStringList("cards"));
    prevCards.add(json.encode(widget.shopCard.toJson()).toString());
    prefs.setStringList("cards", prevCards);
    Navigator.of(context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("New element"),
      ),
      body: new Center(
          child: new Column(
        children: <Widget>[
          new TextField(
            decoration: new InputDecoration(
              hintText: "Card",
              contentPadding: new EdgeInsets.all(10.0),
            ),
            controller: _cardIdCtrl,
          ),
          new Container(
            child: new Column(
              children: widget.shopList.map((Shop _shop) {
                return new ShopWidget(_shop);
              }).toList(),
            ),
          ),
          new Row(
            children: <Widget>[
              new Text("Bought"),
              new Checkbox(
                value: widget.shopCard.bought,
                onChanged: (_val) => setState(() {
                      widget.shopCard.bought = _val;
                    }),
              )
            ],
          ),
          new RaisedButton(
            onPressed: _addElement,
          )
        ],
      )),
    );
  }
}
