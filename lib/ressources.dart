import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aru/card.dart';

const String PATH = 'cards/TT2KX6lQljP6sB5WFgDf';

class Ressource {
  static Future update(List<ShopCard> newCards, {String path = PATH}) {
    Map<String, dynamic> _newCards = ShopCard.toFirestore(newCards);
    var future = Firestore.instance.document(path).updateData(_newCards);

    return future;
  }

  static Future getAll({String path = PATH, Completer completer}) async {
    if (completer == null) {
      completer = new Completer();
    }
    var future = Firestore.instance.document(path).get();
    List<ShopCard> _cardList = [];

    future.then((data) {
      for (var f in data['shopcards']) {
        _cardList.add(new ShopCard.fromStringc(f));
      }
      completer.complete(_cardList);
      return _cardList;
    });
    return completer.future;
  }
}
