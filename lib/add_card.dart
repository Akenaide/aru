import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddElementWidget extends StatefulWidget {
  ShopCard shopCard;

  AddElementWidget(this.shopCard);

  @override
  _AddElement createState() => new _AddElement();
}

class _AddElement extends State<AddElementWidget> {
  // final TextStyle _textStyle = new TextStyle(fontSize: 20.0);
  _AddElement();

  _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prevCards = prefs.getStringList("cards");
    prevCards.add(widget.shopCard.toString());
    prefs.setStringList("cards", prevCards);
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
          ),
          new TextField(
            decoration: new InputDecoration(
              hintText: "Shop / price",
              contentPadding: new EdgeInsets.all(10.0),
            ),
          ),
          new Row(
            children: <Widget>[
              new Text("Bought"),
              new Checkbox(
                value: false,
              )
            ],
          ),
          new RaisedButton(
            child: new Text("Add"),
          )
        ],
      )),
    );
  }
}
