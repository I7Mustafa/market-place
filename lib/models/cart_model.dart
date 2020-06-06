class CartModel {
  String userId;
  String itemId;
  String itemName;
  String itemImg;
  String sallerName;
  String itemPrice;
  int numberOfItems;

  CartModel({
    this.userId,
    this.itemId,
    this.itemImg,
    this.itemName,
    this.itemPrice,
    this.numberOfItems,
    this.sallerName,
  });
}
