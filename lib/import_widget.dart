import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:aru/card.dart';

class ImportWidget extends StatefulWidget {
  final TextEditingController _controller = new TextEditingController();
  final String wsdeckUrl = "https://wsdecks.com/deck/";
  final String pmUrl = "https://proxymaker.naide.moe/views/estimateprice";
  final List<CardWS> cards = [];

  @override
  State createState() {
    return _ImportState();
  }
}

class _ImportState extends State<ImportWidget> {
  Future<http.Response> fetchDeck(String wsdeck) {
    return http.post(this.widget.pmUrl, body: {"url": wsdeck});
  }

  void _import() async {
    var data = await fetchDeck(
        "${this.widget.wsdeckUrl}${this.widget._controller.text}/");
    var _cards = CardWS.listFromString(data.body);
    setState(() {
      this.widget.cards.addAll(_cards);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("Import from wsdeck"),
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
                onPressed: _import,
              )
            ],
          ),
          new TextField(
            autofocus: true,
            controller: this.widget._controller,
            keyboardType: TextInputType.number,
          ),
          new Column(
            children: this.widget.cards.isEmpty
                ? [const Text("No data")]
                : this.widget.cards.map((CardWS card) {
                    return new CardWSWidget(card);
                  }).toList(),
          )
        ],
      ),
    );
  }
}

class CardWSWidget extends StatelessWidget {
  final CardWS card;
  CardWSWidget(this.card) : super();
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Card ID",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new Text(this.card.id),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Amount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              new Text(this.card.amount.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
