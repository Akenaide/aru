import 'package:flutter/material.dart';

import 'package:aru/card.dart';

class NewShopWidget extends StatefulWidget {
  NewShopWidget(this.shop, this._delete);
  final Shop shop;
  final Function(String) _delete;

  @override
  _NewShop createState() => new _NewShop();
}

class _NewShop extends State<NewShopWidget> {
  TextEditingController _nameCtrl = new TextEditingController();
  TextEditingController _priceCtrl = new TextEditingController();

  void _updateName() {
    this.widget.shop.name = _nameCtrl.text;
  }

  void _updatePrice() {
    this.widget.shop.price = int.parse(_priceCtrl.text);
  }

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = this.widget.shop.name;
    _priceCtrl.text = this.widget.shop.price.toString();

    _nameCtrl.addListener(_updateName);
    _priceCtrl.addListener(_updatePrice);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_updateName);
    _priceCtrl.removeListener(_updatePrice);
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NewShopWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shop != this.widget.shop) {
      _nameCtrl.text = this.widget.shop.name;
      _priceCtrl.text = this.widget.shop.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      elevation: 10.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Shop name",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new IconButton(
                color: Colors.red,
                icon: const Icon(Icons.delete),
                tooltip: 'Delete shop',
                onPressed: () => widget._delete(widget.shop.name),
              )
            ],
          ),
          new TextField(
            controller: _nameCtrl,
            decoration: new InputDecoration(
              hintText: "Shop",
              icon: const Icon(Icons.business),
            ),
            maxLength: 10,
          ),
          const Text(
            "Price",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          new TextField(
            controller: _priceCtrl,
            decoration: new InputDecoration(
              hintText: "Price",
              icon: const Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
