import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

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
              onChanged: (_val) => widget.shop.price = int.parse(_val)),
        ),
      ],
    );
  }
}

class AddElementWidget extends StatefulWidget {
  AddElementWidget();

  @override
  _AddElement createState() => new _AddElement();
}

class _AddElement extends State<AddElementWidget> {
  final TextEditingController _cardIdCtrl = new TextEditingController();
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _priceCtrl = new TextEditingController();

  ShopCard shopCard;
  List<Shop> shopList = [
    new Shop(),
  ];

  @override
  void initState() {
    super.initState();
    this.shopCard = new ShopCard.empty("");
  }

  _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.shopList.forEach((Shop shop) {
      this.shopCard.stores[shop.name] = shop.price;
    });
    this.shopCard.cardId = _cardIdCtrl.text;
    List<String> prevCards = [];
    prevCards.addAll(prefs.getStringList("cards"));
    prevCards.add(json.encode(shopCard.toJson()).toString());
    prefs.setStringList("cards", prevCards);
    Navigator.of(context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> shopsW = [];
    for (int i = 0; i < this.shopList.length; i++) {
      shopsW.add(new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "Shop",
              ),
              onChanged: (_val) => this.shopList[i].name = _val,
            ),
          ),
          new Flexible(
            child: new TextField(
              decoration: new InputDecoration(
                hintText: "Price",
              ),
              keyboardType: TextInputType.number,
              onChanged: (_val) => this.shopList[i].price = int.parse(_val),
            ),
          ),
        ],
      ));
    }
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
              children: shopsW,
            ),
          ),
          new Row(
            children: <Widget>[
              new Text("Bought"),
              new Checkbox(
                value: this.shopCard.bought,
                onChanged: (_val) => setState(() {
                      this.shopCard.bought = _val;
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
