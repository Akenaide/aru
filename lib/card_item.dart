import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:aru/card.dart';

class ShopRow extends StatefulWidget {
  final ShopCard _shopCard;

  ShopRow(this._shopCard);

  @override
  _ShopRowState createState() => new _ShopRowState();
}

class _ShopRowState extends State<ShopRow> {
  _ShopRowState();

  @override
  Widget build(BuildContext context) {
    List<Widget> shops = [];
    widget._shopCard.stores.forEach((String name, int price) {
      shops.add(new Row(
        children: <Widget>[
          new Text(
            "$name : $price",
            overflow: TextOverflow.clip,
          ),
        ],
      ));
    });
    return new Column(
      children: shops,
    );
  }
}

class Cardrow extends StatefulWidget {
  final ShopCard _shopCard;
  final Function(String) _delete;
  final int index;

  Cardrow(this._shopCard, this._delete, this.index);

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<Cardrow> {
  _CardItemState();
  toggleBought(bool newValue) {
    setState(() {
      widget._shopCard.bought = newValue;
    });
  }

  void cacheSelectedCard(ShopCard selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedCard", json.encode(selected.toJson()).toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 2.0),
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          color: this.widget.index.isEven ? Colors.white : Colors.black12,
        ),
        child: new Row(
          children: <Widget>[
            new SizedBox(
                width: 70.0,
                child: new Text(
                  widget._shopCard.cardId,
                )),
            new Expanded(
              child: new ShopRow(widget._shopCard),
            ),
            new Checkbox(
              value: widget._shopCard.bought,
              onChanged: toggleBought,
            ),
            new PopupMenuButton(
              onSelected: (String action) {
                switch (action) {
                  case "edit":
                    Navigator.of(context).pushNamed('/editelement');
                    cacheSelectedCard(widget._shopCard);
                    break;

                  case "delete":
                    widget._delete(widget._shopCard.cardId);
                    break;
                  default:
                }
              },
              itemBuilder: (context) {
                return [
                  new PopupMenuItem(
                    value: "edit",
                    child: new Row(
                      children: <Widget>[
                        const Icon(
                          Icons.edit,
                          semanticLabel: "Edit",
                        ),
                        const Text("Edit"),
                      ],
                    ),
                  ),
                  new PopupMenuItem(
                    value: "delete",
                    child: new Row(
                      children: <Widget>[
                        const Icon(
                          Icons.delete,
                          semanticLabel: "Delete",
                        ),
                        const Text("Delete"),
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
      ),
    );
  }
}
