import "dart:convert";

class ShopCard {
  ShopCard.full(this.cardId, this.stores, this.bought);

  ShopCard.empty(String init) {
    cardId = init;
    bought = false;
    stores = new Map();
  }

  ShopCard.fromStringc(data) {
    cardId = data["cardId"];
    bought = data["bought"];
    stores = Map.castFrom(data["stores"]);
  }

  ShopCard.fromCardWS(CardWS card) {
    this.cardId = card.id;
    this.bought = false;
    this.stores = {"yyt": card.price};
  }

  dynamic toJson() {
    return {
      "cardId": this.cardId,
      "bought": this.bought,
      "stores": this.stores,
    };
  }

  String prepToString() {
    return json.encode(this.toJson()).toString();
  }

  static List<String> replaceIn(
      ShopCard newShop, ShopCard previousShop, List<String> allShops) {
    List<String> result;
    List<ShopCard> shops = allShops.map((String _toConvert) {
      return new ShopCard.fromStringc(_toConvert);
    }).toList();
    num index = shops.indexWhere((ShopCard _shop) {
      return _shop.cardId == newShop.cardId;
    });
    shops.insert(index, newShop);
    shops.removeAt(index + 1);

    result = shops.map((ShopCard _shop) {
      return _shop.prepToString();
    }).toList();
    return result;
  }

  String cardId;
  Map<String, int> stores;
  bool bought;
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
  // String imageUrl;

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
  }
}
