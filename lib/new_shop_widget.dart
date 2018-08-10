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

  @override
  Widget build(BuildContext context) {
    _nameCtrl.text = this.widget.shop.name;
    _priceCtrl.text = this.widget.shop.price.toString();
    return new Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      elevation: 10.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              const Text(
                "Shop name",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new IconButton(
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
            onChanged: (_val) => setState(() {
                  this.widget.shop.name = _val;
                }),
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
            onChanged: (_val) => setState(() {
                  this.widget.shop.price = int.parse(_val);
                }),
          ),
        ],
      ),
    );
  }
}
