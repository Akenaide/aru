import 'package:flutter/material.dart';

import 'package:aru/card_item.dart';
import 'package:aru/card.dart';

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
        '/addelement': (BuildContext context) => new _AddElement(),
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
  final List<ShopCard> cardList = [
    new ShopCard("yay", {"akiba": 41, "magic": 52}, false),
    new ShopCard("hop", {"akiba": 20, "magic": 18}, true),
    new ShopCard("yoo", {"akiba": 10, "magic": 5}, false),
  ];

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _AddElement extends StatelessWidget {
  final TextStyle _textStyle = new TextStyle(fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return  new Container(
            color: Colors.green,
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  // top: 25.0,
                  child: new Center(
                    child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Text("CardName", style: _textStyle),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            "Shops",
                            style: _textStyle,
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            "bought",
                            style: _textStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              ],
            ));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that
        // Here we take the value from the MyHomePage object that
        // was created by the App.build method, and use it to set
        // our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and
        // positions it in the middle of the parent.
        child: new Column(
          children: widget.cardList.map((ShopCard card) {
            return new CardItem(card);
          }).toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addelement');
        },
        tooltip: 'New element',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
