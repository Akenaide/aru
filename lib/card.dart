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
    stores = _json["stores"];
    bought = _json["bought"];
  }

  dynamic toJson() {
    return {
      "cardId": this.cardId,
      "bought": this.bought,
    };
  }

  String cardId;
  Map<String, int> stores;
  bool bought;
}

class Shop {
  String name;
  int price;
}
