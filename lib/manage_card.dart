import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/new_shop_widget.dart';
import 'package:aru/ressources.dart';

class ManageShopCardWidget extends StatefulWidget {
  final String action;
  final ShopCard shopCard;

  ManageShopCardWidget(this.action, {this.shopCard});

  @override
  State createState() {
    switch (this.action) {
      case "edit":
        return new _EditElement("Edit", shopCard: this.shopCard);
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
  final TextEditingController _neededAmountCtrl = new TextEditingController();
  Ressource _ressource = Ressource();
  List<Shop> shopList = [];
  ShopCard shopCard;

  void _delete(String shop) {
    List<Shop> _shopList = [];
    _shopList.addAll(this.shopList.where((item) => item.name != shop));
    setState(() {
      shopList = _shopList;
    });
  }

  _performAdd(List<ShopCard> dbCards, [ShopCard updatedShop]) {
    throw new UnimplementedError();
  }

  void _addElement() async {
    List<ShopCard> dbCards;
    ShopCard updatedShop = shopCard;

    await _ressource.getAll().then((data) {
      dbCards = data;
    });

    updatedShop.stores = new Map<String, int>();
    this.shopList.forEach((Shop shop) {
      updatedShop.stores[shop.name] = shop.price;
    });

    updatedShop.cardId = _cardIdCtrl.text;
    updatedShop.nbBought = int.parse(_cardQuantityCtrl.text);
    updatedShop.amount = int.parse(_neededAmountCtrl.text);
    _performAdd(dbCards, updatedShop);

    Navigator.of(context).pop();
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
                new Container(
                  width: 90.0,
                  child: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Quantity",
                      contentPadding: new EdgeInsets.all(10.0),
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                    textAlign: TextAlign.end,
                    controller: _cardQuantityCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Text(" / "),
                new Container(
                  width: 50.0,
                  child: new TextField(
                    textAlign: TextAlign.end,
                    controller: _neededAmountCtrl,
                    keyboardType: TextInputType.number,
                  ),
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

  _ManageElement(this.title, {this.shopCard});
}

class _EditElement extends _ManageElement {
  @override
  _performAdd(dbCards, [ShopCard updatedShop]) {
    _ressource.update(updatedShop);
  }

  @override
  void initState() {
    super.initState();
    _cardIdCtrl.text = shopCard.cardId;
    _neededAmountCtrl.text = shopCard.amount.toString();
    _cardQuantityCtrl.text = shopCard.nbBought.toString();
    shopCard.stores.forEach((String name, int price) {
      shopList.add(new Shop.full(name, price));
    });
  }

  _EditElement(title, {shopCard}) : super(title, shopCard: shopCard);
}

class _AddElement extends _ManageElement {
  @override
  _performAdd(dbCards, [ShopCard updatedShop]) {
    dbCards.add(updatedShop);
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
