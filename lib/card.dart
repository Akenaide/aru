import "dart:convert";

class ShopCard {
  ShopCard.full(this.cardId, this.stores, this.bought, this.imageurl);

  ShopCard.empty(String init) {
    cardId = init;
    bought = false;
    stores = new Map();
    imageurl = "";
  }

  ShopCard.fromStringc(data) {
    var _json = json.decode(data);
    cardId = _json["cardId"];
    bought = _json["bought"];
    imageurl = _json["imageurl"];
    stores = new Map();
    _json["stores"].forEach((String key, value) {
      stores.putIfAbsent(key, () => value);
    });
  }

  ShopCard.fromCardWS(CardWS card) {
    this.cardId = card.id;
    this.bought = false;
    this.stores = {"yyt": card.price};
    this.imageurl = card.imageUrl;
  }

  Map<String, dynamic> toJson() {
    return {
      "cardId": this.cardId,
      "bought": this.bought,
      "stores": this.stores,
      "imageurl": this.imageurl,
    };
  }

  String prepToString() {
    return json.encode(this.toJson()).toString();
  }

  static Map<String, dynamic> toFirestore(List<ShopCard> cards) {
    return {
      "shopcards": cards.map((f) {
        return f.toJson();
      }).toList()
    };
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

  String cardId;
  Map<String, int> stores;
  bool bought;
  String imageurl;
}

class Shop {
  String name;
  int price;

  Shop.full(this.name, this.price);
  Shop.empty() {
    name = "";
    price = 0;
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
