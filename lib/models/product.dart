class Product {
  String productId;
  String sallerId;
  String companyName;
  String productName;
  String productType;
  String price;
  String quantity;
  String description;
  String specification;
  List productImages;

  Product({
    this.sallerId,
    this.companyName,
    this.productId,
    this.productType,
    this.productName,
    this.price,
    this.quantity,
    this.description,
    this.specification,
    this.productImages,
  });
}
