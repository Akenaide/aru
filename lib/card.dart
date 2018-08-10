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
