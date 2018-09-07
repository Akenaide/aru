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

  void _import() async {
    List<ShopCard> dbCards;

    await Ressource.getAll().then((data) {
      dbCards = data;
    });

    for (var card in this.cards) {
      if (card.selected) {
        dbCards.insert(0, new ShopCard.fromCardWS(card));
      }
    }
    Ressource.update(dbCards);
    Navigator.of(context).pushReplacementNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("Import from wsdeck"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: _import,
          )
        ],
      ),
      body: new ListView(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
                icon: const Icon(Icons.file_download),
                tooltip: 'Delete shop',
                onPressed: _fetch,
              )
            ],
          ),
          new TextField(
            autofocus: true,
            controller: this._controller,
            keyboardType: TextInputType.number,
            onSubmitted: (_val) {
              _fetch();
            },
          ),
          new Column(
            children: this.cards.isEmpty
                ? [const Text("No data")]
                : this.cards.map((CardWS card) {
                    return new CardWSWidget(card);
                  }).toList(),
          )
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
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Card ID",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(this.widget.card.id),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Amount",
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
