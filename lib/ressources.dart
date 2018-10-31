import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'package:aru/card.dart';
import 'package:aru/globals.dart' show fsi;

const bool ENABLE_FS = true;
const String ProxySingleUrl = "https://proxymaker.naide.moe/views/searchcards";

class Ressource {
  String fsPath = '';
  bool _isLogged = false;
  static final Ressource _ressource = new Ressource._internal();

  Ressource._internal();

  factory Ressource() {
    return _ressource;
  }

  set username(String newLogin) {
    fsPath = "users/$newLogin/cards";
    _isLogged = newLogin.isNotEmpty;
  }

  Future delete(String id) async {
    var fs = fsi.collection(this.fsPath);
    fs.document(id).delete();
  }

  Future update(ShopCard newCards) async {
    var fs = fsi.collection(this.fsPath);
    fs.document(newCards.id).updateData(newCards.toJson());
  }

  Future add(List<ShopCard> newCards) async {
    var fs = fsi.collection(this.fsPath);
    if (ENABLE_FS) {
      List<Map<String, dynamic>> _newCards = ShopCard.toFirestore(newCards);
      for (var card in _newCards) {
        fs.add(card);
      }
    } else {
      List<String> prevCards = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prevCards = newCards.map((ShopCard card) {
        return card.prepToString();
      }).toList();
      prefs.setStringList("cards", prevCards);
    }
  }

  dynamic fetchCardInfo(String cardId) async {
    Map<String, dynamic> data;
    http.Client client = new http.Client();
    http.Response response = await client.get(ProxySingleUrl + "?id=$cardId");
    if (response.statusCode != 200) {
      print(response.body);
      throw http.ClientException;
    }
    data = json.decode(response.body);
    return data;
  }

  Future updatePrice(List<ShopCard> cards) async {
    var fs = fsi.collection(this.fsPath);

    for (ShopCard card in cards) {
      var data;
      try {
        data = await fetchCardInfo(card.cardId);
      } catch (ClienException) {
        continue;
      }
      card.stores["yyt"] = data["Price"];
      fs.document(card.id).updateData(card.toJson());
    }
  }

  Future getAll({Completer completer}) async {
    if (completer == null) {
      completer = new Completer();
    }
    List<ShopCard> _cardList = [];

    if (ENABLE_FS) {
      if (!_isLogged) {
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
            f.documentID,
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
