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
      cardList =  widget._cardList;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: GridView.custom(
        childrenDelegate: new SliverChildListDelegate(cardList.isEmpty
            ? [new Text("No data")]
            : cardList.map((ShopCard card) {
                return new CardWidget(
                    card, _deleteCard, cardList.indexOf(card));
              }).toList()),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.45,
          crossAxisCount: 3,
        ),
      ),
    );
  }
}
