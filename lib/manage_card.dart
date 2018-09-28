import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aru/card.dart';
import 'package:aru/new_shop_widget.dart';
import 'package:aru/ressources.dart';

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
  final TextEditingController _cardQuantityCtrl = new TextEditingController();
  List<Shop> shopList = [];
  ShopCard shopCard;

  void _delete(String shop) {
    List<Shop> _shopList = [];
    _shopList.addAll(this.shopList.where((item) => item.name != shop));
    setState(() {
      shopList = _shopList;
    });
  }

  List<ShopCard> _performAdd(List<ShopCard> dbCards, [ShopCard updatedShop]) {
    throw new UnimplementedError();
  }

  void _add() {
    _cardQuantityCtrl.text = (int.parse(_cardQuantityCtrl.text) + 1).toString();
  }

  void _sub() {
    _cardQuantityCtrl.text = (int.parse(_cardQuantityCtrl.text) - 1).toString();
  }

  void _addElement() async {
    List<ShopCard> prevCards = [];
    List<ShopCard> dbCards;
    ShopCard updatedShop = shopCard;

    await Ressource.getAll().then((data) {
      dbCards = data;
    });

    updatedShop.stores = new Map<String, int>();
    this.shopList.forEach((Shop shop) {
      updatedShop.stores[shop.name] = shop.price;
    });

    updatedShop.cardId = _cardIdCtrl.text;
    updatedShop.nbBought = int.parse(_cardQuantityCtrl.text);
    prevCards = _performAdd(dbCards, updatedShop);

    Ressource.update(prevCards);
    Navigator.of(context).pushReplacementNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${this.title} element"),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _addElement,
          )
        ],
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
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Quantity",
                      contentPadding: new EdgeInsets.all(10.0),
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                    controller: _cardQuantityCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Text("/ ${shopCard.amount}"),
                new IconButton(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                ),
                new IconButton(
                  onPressed: _sub,
                  icon: const Icon(Icons.remove),
                ),
              ],
            ),
            new Column(
              children: this.shopList.map((Shop shop) {
                return new NewShopWidget(shop, this._delete);
              }).toList(),
            ),
            new Row(
              children: <Widget>[],
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            this.shopList.add(new Shop.empty());
          });
        },
        tooltip: 'New element',
        child: new Icon(Icons.add),
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
    _cardQuantityCtrl.text = _shopCard.nbBought.toString();
    _shopCard.stores.forEach((String name, int price) {
      _shopList.add(new Shop.full(name, price));
    });
    setState(() {
      shopCard = _shopCard;
      shopList = _shopList;
    });
  }

  @override
  List<ShopCard> _performAdd(dbCards, [ShopCard updatedShop]) {
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
  List<ShopCard> _performAdd(dbCards, [ShopCard updatedShop]) {
    dbCards.add(updatedShop);
    return dbCards;
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
