import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/card_item.dart';
import 'package:aru/ressources.dart';
import 'package:aru/globals.dart';

class ListCardWidget extends StatefulWidget {
  final List<ShopCard> _cardList;
  final Color color;
  _ListCardWidgetState createState() => _ListCardWidgetState();

  ListCardWidget(this._cardList, {this.color: Colors.white});
}

class _ListCardWidgetState extends State<ListCardWidget> {
  Ressource _ressource = new Ressource();

  void _deleteCard(String selected) async {
    _ressource.delete(selected);
    setState(() {
      widget._cardList.removeWhere((ShopCard card) {
        return card.id == selected;
      });
    });
  }

  @override
  void initState() {
    quantityStream.stream.listen((onData) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SliverGrid grid = SliverGrid.count(
      children: (widget._cardList.isEmpty
          ? [new Text("No data")]
          : widget._cardList.map((ShopCard card) {
              return new CardWidget(card, _deleteCard, color: widget.color,);
            }).toList()),
      childAspectRatio: 0.45,
      crossAxisCount: 3,
    );

    return grid;
  }
}
