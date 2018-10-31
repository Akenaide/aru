import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aru/card_item.dart';
import 'package:aru/card.dart';
import 'package:aru/manage_card.dart';
import 'package:aru/import_widget.dart';
import 'package:aru/ressources.dart';
import 'package:aru/totalprice_widget.dart';
import 'package:aru/globals.dart' show fsi;

const AruLoginKey = "AruLogin";

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
    _ressource.delete(selected);
    setState(() {
      cardList.removeWhere((ShopCard card) {
        return card.id == selected;
      });
    });
  }

  Future _getSetLogin() async {
    Completer _completer = new Completer();
    var pref = await SharedPreferences.getInstance();
    if (_username.text.isEmpty) {
      String username = pref.get(AruLoginKey);
      if (username.isNotEmpty) {
        _ressource.username = username;
        _username.text = username;
      }
    } else {
      pref.setString(AruLoginKey, _username.text);
    }
    _completer.complete("");
    return _completer.future;
  }

  _updatePrice() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return new Dialog(
          child: new Row(
            children: <Widget>[
              new CircularProgressIndicator(),
              const Text("Update yyt prices"),
            ],
          ),
        );
      },
    );
    await _ressource.updatePrice(cardList);
    setState(() {
      cardList = cardList;
    });
    Navigator.pop(context);
  }

  Future<void> _getInitial() async {
    Completer _completer = new Completer();
    _getSetLogin().then((_) {
      _ressource.getAll(completer: _completer);
    });

    _completer.future.then((data) async {
      setState(() {
        cardList = data;
      });
    });
    return _completer.future;
  }

  _logout() async {
    _username.clear();
    _ressource.username = '';
    var pref = await SharedPreferences.getInstance();
    pref.setString(AruLoginKey, '');
    setState(() {
      cardList.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _init = _getInitial();
  }

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerChildren = [
      new Container(
        height: 80.0,
        child: const DrawerHeader(
          child: const Text("Aru"),
        ),
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
        onTap: () async {
          var result = await Navigator.of(context).pushNamed("/addelement");
          if (result != null) {
            setState(() {
              cardList.add(result);
            });
            Navigator.of(context).pop();
          }
        },
      ),
      new ListTile(
        leading: new Icon(Icons.refresh),
        title: const Text("Update yyt prices"),
        onTap: () {
          Navigator.of(context).pop();
          _updatePrice();
        },
      ),
      new Divider(),
      new TextField(
        controller: _username,
      ),
      new ListTile(
        leading: new Icon(Icons.exit_to_app),
        title: const Text("Login"),
        onTap: () {
          if (_username.text != '') {
            _ressource.username = _username.text;
            _getInitial();
            Navigator.of(context).pop();
          }
        },
      ),
      new ListTile(
        leading: new Icon(Icons.power_settings_new),
        title: const Text("Logout"),
        onTap: () {
          _logout();
          Navigator.of(context).pop();
        },
      ),
    ];

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
          children: drawerChildren,
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
                return new Column(
                  children: <Widget>[
                    new TotalPrice(cardList),
                    new Expanded(
                      child: GridView.custom(
                        childrenDelegate:
                            new SliverChildListDelegate(cardList.isEmpty
                                ? [new Text("No data")]
                                : cardList.map((ShopCard card) {
                                    return new CardWidget(card, _deleteCard,
                                        cardList.indexOf(card));
                                  }).toList()),
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.45,
                          crossAxisCount: 3,
                        ),
                      ),
                    ),
                  ],
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
