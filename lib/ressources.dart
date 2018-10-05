import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aru/card.dart';
import 'package:aru/main.dart' show fsi;

// const String PATH = 'cards/TT2KX6lQljP6sB5WFgDf';
const String PATH = 'cards/TT2KX6lQljP6sB5WFgDg';
const bool ENABLE_FS = true;

class Ressource {
  String fsPath = PATH;
  static final Ressource _ressource = new Ressource._internal();

  Ressource._internal();

  factory Ressource() {
    return _ressource;
  }

  String get path {
    return fsPath;
  }

  set path(String newPath) {
    fsPath = newPath;
  }

  Future update(List<ShopCard> newCards) async {
    var fs = fsi.collection(this.fsPath);
    if (ENABLE_FS) {
      List<Map<String, dynamic>> _newCards = ShopCard.toFirestore(newCards);
      for (var card in _newCards) {
        fs.add(card);
      }
      // fs.where("cardId", isEqualTo: key).getDocuments().then((QuerySnapshot data){
      //   data.documents.
      // });

      // var future = fs.setData(_newCards);

      // return future;
    } else {
      List<String> prevCards = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prevCards = newCards.map((ShopCard card) {
        return card.prepToString();
      }).toList();
      prefs.setStringList("cards", prevCards);
    }
  }

  Future getAll({Completer completer}) async {
    if (completer == null) {
      completer = new Completer();
    }
    List<ShopCard> _cardList = [];

    if (ENABLE_FS) {
      if (this.path == '') {
        completer.complete(_cardList);
        return _cardList;
      }
      var fs = fsi.collection(this.fsPath);
      var future = fs.getDocuments();

      future.then((QuerySnapshot data) {
        for (var f in data.documents) {
          _cardList.add(new ShopCard.full(
            f["cardId"],
            Map.castFrom(f["stores"]),
            f["imageurl"],
            f["amount"],
            f["nbBought"],
          ));
        }
        completer.complete(_cardList);
        return _cardList;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var _local = prefs.getStringList('cards');
      if (_local == null) {
        prefs.setStringList("cards", []);
      } else {
        _cardList.addAll(_local.map((item) => new ShopCard.fromStringc(item)));
      }
      completer.complete(_cardList);
    }
    return completer.future;
  }
}
