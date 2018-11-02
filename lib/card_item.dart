import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aru/card.dart';
import 'package:aru/manage_card.dart';
import 'package:aru/ressources.dart';
import 'package:aru/globals.dart';

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
        "$name : ${intlNumber.format(price)}",
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
  final Color color;

  CardWidget(this._shopCard, this._delete, {this.color = Colors.white});
  CardWidget.grey(this._shopCard, this._delete, {this.color = Colors.grey});

  @override
  _CardItemState createState() => new _CardItemState();
}

class _CardItemState extends State<CardWidget> {
  _CardItemState();

  _navigateAndUpdate(BuildContext context) async {
    await Navigator.push(
        context,
        new MaterialPageRoute<ShopCard>(
            builder: (BuildContext context) =>
                ManageShopCardWidget("edit", shopCard: widget._shopCard)));
  }

  void _add() {
    Ressource ressource = Ressource();
    quantityStream.add(widget._shopCard.cardId);
    setState(() {
      widget._shopCard.nbBought++;
    });
    ressource.update(widget._shopCard);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: widget.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Text(
                  widget._shopCard.cardId,
                  style: new TextStyle(
                      fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ),
              new PopupMenuButton(
                padding: const EdgeInsets.only(),
                icon: Icon(Icons.keyboard_arrow_down),
                onSelected: (String action) {
                  switch (action) {
                    case "edit":
                      _navigateAndUpdate(context);
                      break;

                    case "delete":
                      widget._delete(widget._shopCard.id);
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
          new GestureDetector(
            child: new CachedNetworkImage(
              placeholder: CircularProgressIndicator(),
              imageUrl: widget._shopCard.imageurl,
            ),
            onDoubleTap: _add,
          ),
          new Text(
              "Bought : ${widget._shopCard.nbBought}/${widget._shopCard.amount}"),
          new Expanded(
            child: new ShopRow(widget._shopCard),
          ),
        ],
      ),
    );
  }
}
