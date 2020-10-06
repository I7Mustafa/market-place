import 'package:flutter/material.dart';
import 'package:market_place/models/product.dart';

class ProductDeteles extends StatelessWidget {
  const ProductDeteles({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.productType,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 4.0),
          Text(
            product.productName,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 4.0),
          Text(
            product.companyName,
            style: Theme.of(context).textTheme.caption,
          ),
          Divider(thickness: 2),
          Text(product.specification),
        ],
      ),
    );
  }
}
