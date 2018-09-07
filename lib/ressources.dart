import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aru/card.dart';

const String PATH = 'cards/TT2KX6lQljP6sB5WFgDf';

class Ressource {
  static final fs = Firestore.instance.document(PATH);

  static Future update(List<ShopCard> newCards) {
    Map<String, dynamic> _newCards = ShopCard.toFirestore(newCards);
    var future = fs.updateData(_newCards);

    return future;
  }

  static Future getAll({Completer completer}) async {
    if (completer == null) {
      completer = new Completer();
    }
    var future = fs.get();
    List<ShopCard> _cardList = [];

    future.then((data) {
      for (var f in data['shopcards']) {
        _cardList.add(new ShopCard.full(f["cardId"], Map.castFrom(f["stores"]), f["bought"]));
      }
      completer.complete(_cardList);
      return _cardList;
    });
    return completer.future;
  }
}
