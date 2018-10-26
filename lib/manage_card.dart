import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/new_shop_widget.dart';
import 'package:aru/ressources.dart';

const String DEFAULT_IMG = "https://proxymaker.naide.moe/static/kokorocafe.png";

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

  _performAdd([ShopCard updatedShop]) {
    throw new UnimplementedError();
  }

  void _addElement() async {
    ShopCard updatedShop = shopCard;
    int _nbBought =
        _cardQuantityCtrl.text.isEmpty ? 0 : int.parse(_cardQuantityCtrl.text);
    int _amount =
        _neededAmountCtrl.text.isEmpty ? 1 : int.parse(_neededAmountCtrl.text);

    updatedShop.stores = new Map<String, int>();
    this.shopList.forEach((Shop shop) {
      updatedShop.stores[shop.name] = shop.price;
    });

    updatedShop
      ..cardId = _cardIdCtrl.text
      ..nbBought = _nbBought
      ..amount = _amount;

    if (updatedShop.imageurl == "") {
      updatedShop.imageurl = DEFAULT_IMG;
    }
    _performAdd(updatedShop);

    Navigator.of(context).pop(updatedShop);
  }

  void _fetch() async {
    var data = await _ressource.fetchCardInfo(_cardIdCtrl.text);
    this.shopCard.imageurl = data["URL"];
    setState(() {
      this.shopList.add(new Shop.full("yyt", data["Price"]));
    });
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
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                      hintText: "Card",
                      contentPadding: new EdgeInsets.all(10.0),
                      icon: const Icon(Icons.payment),
                    ),
                    controller: _cardIdCtrl,
                  ),
                ),
                new RaisedButton(
                  child: const Text("Fetch"),
                  onPressed: _fetch,
                )
              ],
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
  _performAdd([ShopCard updatedShop]) {
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
  _performAdd([ShopCard updatedShop]) {
    _ressource.add([updatedShop]);
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
