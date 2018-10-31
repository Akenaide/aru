import 'package:flutter/material.dart';

import 'package:aru/card.dart';
import 'package:aru/card_item.dart';
import 'package:aru/ressources.dart';

class ListCardWidget extends StatefulWidget {
  final List<ShopCard> _cardList;
  @override
  _ListCardWidgetState createState() => _ListCardWidgetState();

  ListCardWidget(this._cardList);
}

class _ListCardWidgetState extends State<ListCardWidget> {
  List<ShopCard> cardList;
  Ressource _ressource = new Ressource();

  void _deleteCard(String selected) async {
    _ressource.delete(selected);
    setState(() {
      cardList.removeWhere((ShopCard card) {
        return card.id == selected;
      });
    });
  }

  @override
  void initState() {
    cardList = widget._cardList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ShopCard> finished = cardList.where((ShopCard card) {
      return card.nbBought >= card.amount;
    }).toList();

    List<ShopCard> needed = cardList.where((ShopCard card) {
      return card.nbBought < card.amount;
    }).toList();

    SliverGrid gridNeeded = SliverGrid.count(
      children: (needed.isEmpty
          ? [new Text("No data")]
          : needed.map((ShopCard card) {
              return new CardWidget(card, _deleteCard, cardList.indexOf(card));
            }).toList()),
      childAspectRatio: 0.45,
      crossAxisCount: 3,
    );

    SliverGrid gridFinished = SliverGrid.count(
      children: (finished.isEmpty
          ? [new Text("No data")]
          : finished.map((ShopCard card) {
              return new CardWidget(card, _deleteCard, cardList.indexOf(card));
            }).toList()),
      childAspectRatio: 0.45,
      crossAxisCount: 3,
    );

    return new CustomScrollView(
      slivers: <Widget>[
        gridNeeded,
        gridFinished,
      ],
    );
  }
}
