import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aru/card_item.dart';
import 'package:aru/card.dart';
import 'package:aru/add_card.dart';
import 'package:aru/edit_card.dart';

void main() {
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
        '/addelement': (BuildContext context) => new AddElementWidget(),
        '/editelement': (BuildContext context) => new EditElementWidget(),
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

  _getInitial() async {
    List<ShopCard> _cardList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _local = prefs.getStringList('cards');
    if (_local == null) {
      prefs.setStringList("cards", []);
    } else {
      _cardList.addAll(_local.map((item) => new ShopCard.fromStringc(item)));
    }
    _cardList.addAll([
      new ShopCard.full("yay", {"akiba": 41, "magic": 52}, false),
      new ShopCard.full("hop", {"akiba": 20, "magic": 18}, true),
      new ShopCard.full("yoo", {"akiba": 10, "magic": 5}, false),
    ]);
    setState(() {
      cardList = _cardList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitial();
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
      body: new ListView(
        children: cardList.isEmpty
            ? [new Text("No data")]
            : cardList.map((ShopCard card) {
                return new Cardrow(card);
              }).toList(),
      ),
      bottomNavigationBar: new Container(
        color: Colors.grey,
        child: new FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/addelement');
          },
          tooltip: 'New element',
          child: new Icon(Icons.add),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
