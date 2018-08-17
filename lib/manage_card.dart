import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/new_shop_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageShopCardWidget extends StatefulWidget {
  final String action;
  ManageShopCardWidget(this.action);

  @override
  State createState() {
    switch (this.action) {
      case "edit":
        return new _EditElement("Edit");
        break;
      case "add":
        return new _AddElement("Add");
        break;
      default:
        return new _AddElement("Add");
    }
  }
}

class _ManageElement extends State<ManageShopCardWidget> {
  final String title;
  final TextEditingController _cardIdCtrl = new TextEditingController();
  List<Shop> shopList = [];
  ShopCard shopCard;
  bool _checkValue = false;

  void _delete(String shop) {
    List<Shop> _shopList = [];
    _shopList.addAll(this.shopList.where((item) => item.name != shop));
    setState(() {
      shopList = _shopList;
    });
  }

  List<String> _performAdd(List<String> dbCards, [ShopCard updatedShop]) {
    throw new UnimplementedError();
  }

  void _addElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prevCards = [];
    ShopCard updatedShop = new ShopCard.empty("");
    List<String> dbCards = prefs.getStringList("cards");

    updatedShop.stores = new Map<String, int>();
    this.shopList.forEach((Shop shop) {
      updatedShop.stores[shop.name] = shop.price;
    });
    updatedShop.cardId = _cardIdCtrl.text;
    updatedShop.bought = this.shopCard.bought;
    prevCards = _performAdd(dbCards, updatedShop);

    prefs.setStringList("cards", prevCards);
    Navigator.of(context).pushReplacementNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${this.title} element"),
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

  _ManageElement(this.title);
}

class _EditElement extends _ManageElement {
  void _getSelected() async {
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

  @override
  List<String> _performAdd(dbCards, [ShopCard updatedShop]) {
    return ShopCard.replaceIn(updatedShop, this.shopCard, dbCards);
  }

  @override
  void initState() {
    super.initState();
    _getSelected();
  }

  _EditElement(title) : super(title);
}

class _AddElement extends _ManageElement {
  @override
  List<String> _performAdd(dbCards, [ShopCard updatedShop]) {
    List<String> prevCards = [];
    prevCards.add(updatedShop.prepToString());
    prevCards.addAll(dbCards);
    return prevCards;
  }

  @override
  void initState() {
    super.initState();
    this.shopCard = new ShopCard.empty("");
    this.shopList.add(
          new Shop.empty(),
        );
  }

  _AddElement(title) : super(title);
}
