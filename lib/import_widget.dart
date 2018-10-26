import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:aru/card.dart';
import 'package:aru/ressources.dart';

class ImportWidget extends StatefulWidget {
  final String wsdeckUrl = "https://wsdecks.com/deck/";
  final String pmUrl = "https://proxymaker.naide.moe/views/estimateprice";

  @override
  State createState() {
    return _ImportState();
  }
}

class _ImportState extends State<ImportWidget> {
  final TextEditingController _controller = new TextEditingController();
  final List<CardWS> cards = [];
  Future<http.Response> fetchDeck(String wsdeck) {
    return http.post(this.widget.pmUrl, body: {"url": wsdeck});
  }

  void _fetch() async {
    var data =
        await fetchDeck("${this.widget.wsdeckUrl}${this._controller.text}/");
    var _cards = CardWS.listFromString(data.body);
    _cards.sort((CardWS a, CardWS b) {
      return a.id.compareTo(b.id);
    });
    setState(() {
      this.cards.addAll(_cards);
      _controller.clear();
    });
  }

  void _selectAll() {
    setState(() {
      for (var card in cards) {
        card.selected = true;
      }
    });
  }

  void _import() async {
    List<ShopCard> newCards = [];
    Ressource ressource = Ressource();

    for (var card in this.cards) {
      if (card.selected) {
        newCards.add(new ShopCard.fromCardWS(card));
      }
    }
    ressource.add(newCards);
    Navigator.of(context).pushReplacementNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cardWidgets = [const Text("No data")];
    List<Widget> actions = <Widget>[
      new IconButton(
        icon: new Icon(Icons.save),
        onPressed: _import,
      ),
    ];

    if (this.cards.isNotEmpty) {
      actions.add(new IconButton(
        icon: new Icon(Icons.select_all),
        onPressed: _selectAll,
      ));
      cardWidgets = this.cards.map((CardWS card) {
        return new CardWSWidget(card);
      }).toList();
    }

    return new Scaffold(
      appBar: AppBar(
        title: const Text("Import from wsdeck"),
        actions: actions,
      ),
      body: new Column(
        children: <Widget>[
          const Text(
            "Enter wsdeck id :",
            style: TextStyle(fontSize: 20.0),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  controller: this._controller,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_val) {
                    _fetch();
                  },
                ),
              ),
              new RaisedButton(
                child: const Text("Fetch"),
                onPressed: _fetch,
              )
            ],
          ),
          new Expanded(
              child: new GridView.count(
            crossAxisCount: 4,
            children: cardWidgets,
          )),
        ],
      ),
    );
  }
}

class CardWSWidget extends StatefulWidget {
  final CardWS card;
  CardWSWidget(this.card) : super();

  @override
  State<StatefulWidget> createState() {
    return _CardWSState();
  }
}

class _CardWSState extends State<CardWSWidget> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        setState(() {
          this.widget.card.selected = !this.widget.card.selected;
        });
      },
      child: new Card(
        color: this.widget.card.selected ? Colors.amber : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Card ID: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(this.widget.card.id),
              ],
            ),
            new Row(
              children: <Widget>[
                const Text(
                  "Price: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(this.widget.card.price.toString()),
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Amount: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(this.widget.card.amount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
