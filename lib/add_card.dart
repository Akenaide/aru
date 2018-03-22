import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:aru/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddElementWidget extends StatefulWidget {
  final ShopCard shopCard;

  AddElementWidget(this.shopCard);

  @override
  _AddElement createState() => new _AddElement(this.shopCard);
}

class _AddElement extends State<AddElementWidget> {
  // final TextStyle _textStyle = new TextStyle(fontSize: 20.0);
  ShopCard shopCard;
  _AddElement(this.shopCard);

  _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prevCards = [];
    prevCards.addAll(prefs.getStringList("cards"));
    prevCards.add(JSON.encode(widget.shopCard.toJson()).toString());
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
            onSubmitted: (_val) => setState(() {widget.shopCard.cardId = _val;}),
          ),
          new TextField(
            decoration: new InputDecoration(
              hintText: "Shop / price",
              contentPadding: new EdgeInsets.all(10.0),
            ),
            onSubmitted: (_val) => setState(() {widget.shopCard.stores = JSON.decode(_val);}),
          ),
          new Row(
            children: <Widget>[
              new Text("Bought"),
              new Checkbox(
                value: widget.shopCard.bought,
                onChanged: (_val) => setState(() {widget.shopCard.bought = _val;}),
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
