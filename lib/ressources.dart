import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aru/card.dart';
import 'package:aru/main.dart' show fsi;

const String PATH = 'cards/TT2KX6lQljP6sB5WFgDf';
const bool ENABLE_FS = true;

class Ressource {
  static Future update(List<ShopCard> newCards) async {
    var fs = fsi.document(PATH);
    if (ENABLE_FS) {
      Map<String, dynamic> _newCards = ShopCard.toFirestore(newCards);
      var future = fs.setData(_newCards);

      return future;
    } else {
      List<String> prevCards = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prevCards = newCards.map((ShopCard card) {
        return card.prepToString();
      }).toList();
      prefs.setStringList("cards", prevCards);
    }
  }

  static Future getAll({Completer completer}) async {
    var fs = fsi.document(PATH);
    if (completer == null) {
      completer = new Completer();
    }
    List<ShopCard> _cardList = [];

    if (ENABLE_FS) {
      var future = fs.get();

      future.then((DocumentSnapshot data) {
        if (data.exists) {
          for (var f in data['shopcards']) {
            _cardList.add(new ShopCard.full(
              f["cardId"],
              Map.castFrom(f["stores"]),
              f["imageurl"],
              f["amount"],
              f["nbBought"],
            ));
          }
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
