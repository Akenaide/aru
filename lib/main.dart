import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aru/card_item.dart';
import 'package:aru/card.dart';
import 'package:aru/manage_card.dart';
import 'package:aru/import_widget.dart';
import 'package:aru/ressources.dart';

Firestore fsi = Firestore.instance;

void main() {
  fsi.enablePersistence(true);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Aru',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting
        // the app, try changing the primarySwatch below to Colors.green
        // and then invoke "hot reload" (press "r" in the console where
        // you ran "flutter run", or press Run > Hot Reload App in
        // IntelliJ). Notice that the counter didn't reset back to zero;
        // the application is not restarted.
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Aru'),
      routes: <String, WidgetBuilder>{
        '/addelement': (BuildContext context) =>
            new ManageShopCardWidget("add"),
        '/editelement': (BuildContext context) =>
            new ManageShopCardWidget("edit"),
        '/import': (BuildContext context) => new ImportWidget(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ShopCard> cardList = [];
  Future<void> _init;
  Ressource _ressource = Ressource();
  TextEditingController _username = new TextEditingController();

  void _deleteCard(String selected) async {
    List<ShopCard> _cardList = [];

    await _ressource.getAll().then((data) {
      _cardList = data;
    });

    _cardList.removeWhere((ShopCard card) => card.cardId == selected);

    _ressource.update(_cardList);
    setState(() {
      cardList = _cardList;
    });
  }

  void _update() {
    _ressource.update(cardList);
  }

  Future<void> _getInitial() async {
    Completer _completer = new Completer();
    _ressource.getAll(completer: _completer);

    _completer.future.then((data) {
      setState(() {
        cardList = data;
      });
    });
    return _completer.future;
  }

  @override
  void initState() {
    super.initState();
    _init = _getInitial();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            const DrawerHeader(
              child: const Text("Aru"),
            ),
            new ListTile(
              leading: new Icon(Icons.file_download),
              title: const Text("Import from wsdeck"),
              onTap: () {
                Navigator.of(context).pushNamed("/import");
              },
            ),
            new ListTile(
              leading: new Icon(Icons.add),
              title: const Text("Add single card"),
              onTap: () {
                Navigator.of(context).pushNamed("/addelement");
              },
            ),
          ],
        ),
      ),
      body: new RefreshIndicator(
        child: new FutureBuilder<void>(
          future: _init,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return new Text('Error ${snapshot.error}');
                }
                return new GridView.custom(
                  childrenDelegate: new SliverChildListDelegate(cardList.isEmpty
                      ? [new Text("No data")]
                      : cardList.map((ShopCard card) {
                          return new CardWidget(card, _deleteCard, _update,
                              cardList.indexOf(card));
                        }).toList()),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.45,
                    crossAxisCount: 3,
                  ),
                );
            }
            return null;
          },
        ),
        onRefresh: _getInitial,
      ),
    );
  }
}
