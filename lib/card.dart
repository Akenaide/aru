import "dart:convert";

class ShopCard {
  ShopCard.full(this.cardId, this.stores, this.imageurl, this.amount,
      this.nbBought, this.id);

  bool get bought {
    return this.amount == this.nbBought;
  }

  ShopCard.empty(String init) {
    cardId = init;
    stores = new Map();
    imageurl = "";
    amount = 0;
    nbBought = 0;
  }

  ShopCard.fromStringc(data) {
    var _json = json.decode(data);
    cardId = _json["cardId"];
    imageurl = _json["imageurl"];
    amount = _json["amount"];
    nbBought = _json["nbBought"];
    stores = new Map();
    _json["stores"].forEach((String key, value) {
      stores.putIfAbsent(key, () => value);
    });
  }

  ShopCard.fromCardWS(CardWS card) {
    this.cardId = card.id;
    this.stores = {"yyt": card.price};
    this.imageurl = card.imageUrl;
    this.amount = card.amount;
    this.nbBought = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "cardId": this.cardId,
      "nbBought": this.nbBought,
      "stores": this.stores,
      "imageurl": this.imageurl,
      "amount": this.amount,
    };
  }

  String prepToString() {
    return json.encode(this.toJson()).toString();
  }

  bool isFinished() {
    return nbBought >= amount;
  }

  static List<Map<String, dynamic>> toFirestore(List<ShopCard> cards) {
    return cards.map((f) {
      return f.toJson();
    }).toList();
  }

  static List<ShopCard> replaceIn(
      ShopCard newShop, ShopCard previousShop, List<ShopCard> allShops) {
    num index = allShops.indexWhere((ShopCard _shop) {
      return _shop.cardId == newShop.cardId;
    });
    allShops.insert(index, newShop);
    allShops.removeAt(index + 1);
    return allShops;
  }

  static Map<String, List<ShopCard>> splitFinishedNotFinished(
      List<ShopCard> allCards) {
    List<ShopCard> finished = [];
    List<ShopCard> needed = [];

    for (var card in allCards) {
      if (card.isFinished()) {
        finished.add(card);
      } else {
        needed.add(card);
      }
    }

    return {
      "finished": finished,
      "needed": needed,
    };
  }

  String cardId;
  Map<String, int> stores;
  int nbBought;
  String imageurl;
  int amount;
  String id;
}

class Shop {
  String name;
  int price;
  bool autofocus;

  Shop.full(this.name, this.price, {this.autofocus = false});
  Shop.empty() {
    name = "";
    price = 0;
    autofocus = true;
  }
}

class CardWS {
  String id;
  int amount;
  bool selected = false;
  int price;
  String imageUrl;

  static List<CardWS> listFromString(String elements) {
    List<CardWS> result = [];
    var jElements = json.decode(elements);
    for (Map<String, dynamic> sCard in jElements) {
      // Little hack to hide the Total
      if (sCard["ID"] != "TOTAL") {
        result.add(CardWS.fromJson(sCard));
      }
    }
    return result;
  }

  CardWS.fromJson(Map<String, dynamic> jCard) {
    this.id = jCard["ID"];
    this.amount = jCard["Amount"];
    this.price = jCard["Price"];
    this.imageUrl = jCard["URL"];
  }
}
