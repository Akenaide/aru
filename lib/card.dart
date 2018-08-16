import "dart:convert";

class ShopCard {
  ShopCard.full(this.cardId, this.stores, this.bought);

  ShopCard.empty(String init) {
    cardId = init;
    bought = false;
    stores = new Map();
  }

  ShopCard.fromStringc(data) {
    var _json = json.decode(data);
    cardId = _json["cardId"];
    bought = _json["bought"];
    stores = new Map();
    _json["stores"].forEach((String key, value) {
      stores.putIfAbsent(key, () => value);
    });
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

  static List<String> replaceIn(ShopCard newShop, ShopCard previousShop, List<String> allShops) {
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
