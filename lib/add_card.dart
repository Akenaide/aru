import 'package:flutter/material.dart';

class AddElement extends StatelessWidget {
  final TextStyle _textStyle = new TextStyle(fontSize: 20.0);
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
