import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aru/card.dart';
import 'package:aru/new_shop_widget.dart';
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
  bool _checkValue = false;

  void getSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedString = prefs.getString("selectedCard");
    List<Shop> _shopList = [];
    ShopCard _shopCard;

    _shopCard = new ShopCard.fromStringc(selectedString);
    _cardIdCtrl.text = _shopCard.cardId;
    _checkValue = _shopCard.bought;
    _shopCard.stores.forEach((String name, int price) {
      _shopList.add(new Shop.full(name, price));
    });
    setState(() {
      shopCard = _shopCard;
      shopList = _shopList;
    });
  }

  void cleanSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedCard");
  }

  void _delete(String shop) {
    List<Shop> _shopList = [];
    print("jkl - $shop");
    _shopList.addAll(this.shopList.where((item) => item.name != shop));
    setState(() {
      shopList = _shopList;
    });
  }

  _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prevCards = [];

    this.shopCard.stores = new Map<String, int>();
    this.shopList.forEach((Shop shop) {
      this.shopCard.stores[shop.name] = shop.price;
    });
    this.shopCard.cardId = _cardIdCtrl.text;

    prevCards.add(shopCard.prepToString());
    prevCards.addAll(prefs.getStringList("cards"));
    prefs.setStringList("cards", prevCards);
    Navigator.of(context).pushNamed("/");
  }

  @override
  void initState() {
    super.initState();
    getSelected();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit element"),
      ),
      body: new SingleChildScrollView(
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
            new Column(
              children: this.shopList.map((Shop shop) {
                print("--- ${shop.name}");
                return new NewShopWidget(shop, this._delete);
              }).toList(),
            ),
            new Row(
              children: <Widget>[
                new Text("Bought"),
                new Checkbox(
                  value:
                      _checkValue, // TODO: Dind't found a way to directly init with obj
                  onChanged: (_val) {
                    _checkValue = _val;
                    setState(() {
                      this.shopCard.bought = _val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
