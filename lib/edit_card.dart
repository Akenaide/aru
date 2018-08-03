import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:aru/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditElementWidget extends StatefulWidget {
  EditElementWidget();

  @override
  _EditElement createState() => new _EditElement();
}

class _EditElement extends State<EditElementWidget> {
  final TextEditingController _cardIdCtrl = new TextEditingController();

  ShopCard shopCard;
  List<Shop> shopList = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // this.shopCard = new ShopCard.empty("");
  }

  Future<String> getSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedString = prefs.getString("selectedCard");
    prefs.remove("selectedCard");
    return selectedString;
  }

  void cleanSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedCard");
  }

  _addElement() async {
    if (_formKey.currentState.validate()) {
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
  }

  List<Widget> buildShopList() {
    List<Widget> shopsW = [];
    for (int i = 0; i < this.shopList.length; i++) {
      shopsW.add(
        new Card(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          elevation: 10.0,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Shop name",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new TextFormField(
                initialValue: this.shopList[i].name,
                decoration: new InputDecoration(
                  hintText: "Shop",
                  icon: const Icon(Icons.business),
                ),
                maxLength: 10,
                onFieldSubmitted: (_val) => this.shopList[i].name = _val.trim(),
              ),
              const Text(
                "Price",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new TextFormField(
                initialValue: this.shopList[i].price.toString(),
                decoration: new InputDecoration(
                  hintText: "Price",
                  icon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_val) =>
                    this.shopList[i].price = int.parse(_val),
              ),
            ],
          ),
        ),
      );
    }
    shopsW.add(
      new Row(
        children: <Widget>[
          new Text("Bought"),
          new Checkbox(
            value: this.shopCard?.bought,
            onChanged: (_val) => setState(() {
                  this.shopCard.bought = _val;
                }),
          ),
        ],
      ),
    );
    return shopsW;
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = FutureBuilder(
      future: getSelected(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data != null) {
            this.shopCard = new ShopCard.fromStringc(snapshot.data);
            this.shopCard.stores.forEach((String name, int price) {
              this.shopList.add(new Shop.full(name, price));
            });
          }
        }
        return new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                  hintText: "Card",
                  contentPadding: new EdgeInsets.all(10.0),
                  icon: const Icon(Icons.payment),
                ),
                controller: _cardIdCtrl,
              ),
              new Form(
                key: _formKey,
                child: new Column(
                  children: buildShopList(),
                ),
              ),
            ],
          ),
        );
      },
    );
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit element"),
      ),
      body: _body,
      bottomNavigationBar: new BottomAppBar(
        color: Colors.blue,
        child: new Row(
          children: <Widget>[
            new IconButton(
              onPressed: () {
                setState(() {
                  this.shopList.add(new Shop.empty());
                });
              },
              tooltip: 'New element',
              icon: new Icon(Icons.add),
            ),
            new RaisedButton(
              onPressed: _addElement,
            )
          ],
        ),
      ),
    );
  }
}
