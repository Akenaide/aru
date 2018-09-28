import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aru/card.dart';
import 'package:aru/manage_card.dart';

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
      shops.add(new Text(
        "$name : $price",
        overflow: TextOverflow.clip,
        style: const TextStyle(
          fontSize: 13.0,
        ),
      ));
    });
    return new Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.horizontal,
      spacing: 5.0,
      children: shops,
    );
  }
}

class CardWidget extends StatefulWidget {
  final ShopCard _shopCard;
  final Function(String) _delete;
  final int index;

  CardWidget(this._shopCard, this._delete, this.index);

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<CardWidget> {
  _CardItemState();

  void cacheSelectedCard(ShopCard selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedCard", selected.prepToString());
  }

  _navigateAndUpdate(BuildContext context) async {
    await Navigator.push(context,
        new MaterialPageRoute<ShopCard>(
            builder: (BuildContext context) =>
                ManageShopCardWidget("edit", shopCard: widget._shopCard)));
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                widget._shopCard.cardId,
                style: new TextStyle(fontSize: 12.0),
              ),
              new PopupMenuButton(
                onSelected: (String action) {
                  switch (action) {
                    case "edit":
                      _navigateAndUpdate(context);
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
          new CachedNetworkImage(
            placeholder: CircularProgressIndicator(),
            imageUrl: widget._shopCard.imageurl,
          ),
          new Text(
              "Bought : ${widget._shopCard.nbBought}/${widget._shopCard.amount}"),
          new ShopRow(widget._shopCard),
        ],
      ),
    );
  }
}
