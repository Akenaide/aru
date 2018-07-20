import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:aru/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddElementWidget extends StatefulWidget {
  AddElementWidget();

  @override
  _AddElement createState() => new _AddElement();
}

class _AddElement extends State<AddElementWidget> {
  final TextEditingController _cardIdCtrl = new TextEditingController();

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
    prevCards.add(json.encode(shopCard.toJson()).toString());
    prevCards.addAll(prefs.getStringList("cards"));
    prefs.setStringList("cards", prevCards);
    Navigator.of(context).pushNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> shopsW = [];
    for (int i = 0; i < this.shopList.length; i++) {
      shopsW.add(
        new Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          decoration:
              new BoxDecoration(border: new Border.all(color: Colors.black)),
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Shop",
                ),
                maxLength: 10,
                onChanged: (_val) => this.shopList[i].name = _val,
              ),
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Price",
                ),
                keyboardType: TextInputType.number,
                onChanged: (_val) => this.shopList[i].price = int.parse(_val),
              ),
            ],
          ),
        ),
      );
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
           new ListView(
              children: shopsW,
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
          new IconButton(
            onPressed: () {
              setState(() {
                this.shopList.add(new Shop());
              });
            },
            tooltip: 'New element',
            icon: new Icon(Icons.add),
          ),
          new RaisedButton(
            onPressed: _addElement,
          )
        ],
      )),
    );
  }
}
