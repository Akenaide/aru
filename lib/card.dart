class ShopCard {
  String cardId;
  Map<String, int> stores;
  bool bought;

  ShopCard(this.cardId, this.stores, this.bought);

  ShopCard.empty(String init) {
    cardId = init;
    bought = false;
  }
}
